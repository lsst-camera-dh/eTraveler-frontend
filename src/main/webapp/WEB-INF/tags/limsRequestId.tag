<%-- 
    Document   : limsRequestId
    Created on : Nov 1, 2013, 4:36:11 PM
    Author     : focke
--%>

<%@tag description="Give the job harness an Id for the job" pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<c:set var="allOk" value="true"/>
<c:set var="message" value="Huh. That wasn't supposed to happen."/>

<c:if test="${allOk}">
    <sql:query var="activityQ" >
        select A.id
        from 
        Activity A
        inner join Hardware H on A.hardwareId=H.id
        inner join Process P on A.processId=P.id
        inner join HardwareType HT on HT.id=P.hardwareTypeId
        left join JobStepHistory JSH on JSH.activityId=A.id
        where
        H.lsstId=?<sql:param value="${inputs.unit_id}"/>
        and P.name=?<sql:param value="${inputs.job}"/>
        and P.userVersionString=?<sql:param value="${inputs.version}"/>
        and P.travelerActionMask&(select maskBit from InternalAction where name='harnessedJob')!=0
        and HT.name=?<sql:param value="${inputs.unit_type}"/>
        and A.begin is not null
        and A.end is null
        and A.activityFinalStatusId is null
        order by A.creationTS desc limit 1;
    </sql:query>
    <c:if test="${empty activityQ.rows}">
        <c:set var="allOk" value="false"/>
        <c:set var="message" value="No record found."/>
    </c:if>
    <c:set var="activityRow" value="${activityQ.rows[0]}"/>
</c:if>

<c:if test="${allOk}">
    <sql:query var="prereqQ" >
        select A.id as activityId, A.hardwareId, A.createdBy,
        H.lsstId,
        HT.name as hardwareTypeName, 
        P.name as processName, P.userVersionString
        from
        Prerequisite PI
        inner join Activity A on A.id=PI.prerequisiteActivityId
        inner join Process P on P.id=A.processId
        inner join HardwareType HT on HT.id=P.hardwareTypeId
        inner join Hardware H on H.id=A.hardwareId
        where
        PI.activityId=?<sql:param value="${activityRow.id}"/>
    </sql:query>
    <sql:update >
        insert into JobStepHistory set
        jobHarnessStepId=(select id from JobHarnessStep where name='registered'),
        activityId=?<sql:param value="${activityRow.id}"/>,
        createdBy=?<sql:param value="${inputs.operator}"/>,
        creationTS=UTC_TIMESTAMP();
    </sql:update>
</c:if>

<c:choose>
    <c:when test="${allOk}">
        {
            "jobid": "${activityRow.id}",
            "prereq": [<c:forEach var="prereqRow" items="${prereqQ.rows}" varStatus="status">
                {
                    "jobid": "${prereqRow.activityId}",
                    "unit_type": "${prereqRow.hardwareTypeName}",
                    "unit_id": "${prereqRow.lsstId}",
                    "job": "${prereqRow.processName}",
                    "version": "${prereqRow.userVersionString}",
                    "operator": "${prereqRow.createdBy}"
                }<c:if test="${! status.last}">,</c:if>
            </c:forEach>]
        }
    </c:when>
    <c:otherwise>
        {
            "jobid": null,
            "error": "<c:out value="${message}"/>"
        }
    </c:otherwise>
</c:choose>