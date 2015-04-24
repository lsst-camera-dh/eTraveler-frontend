<%-- 
    Document   : limsUpdate
    Created on : Nov 12, 2013, 1:23:10 PM
    Author     : focke
--%>

<%@tag description="Update progress of a job harness step" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<c:set var="allOk" value="true"/>
<c:set var="message" value="Huh. That wasn't supposed to happen. 663698"/>

<%-- TODO: check step is correct next one --%>
<traveler:findTraveler var="travelerId" activityId="${inputs.jobid}"/>
<c:if test="${allOk}">
    <sql:query var="activityQ" >
select A.*
from Activity A
inner join ActivityStatusHistory ASH on ASH.activityId=A.id and ASH.id=(select max(id) from ActivityStatusHistory where activityId=A.id)
inner join ActivityFinalStatus AFS on AFS.id=ASH.activityStatusId
inner join Process P on P.id=A.processId
where A.id=?<sql:param value="${inputs.jobid}"/>
<c:if test="${inputs.step != 'purged'}">
    and A.end is null
    and AFS.name='inProgress'
</c:if>
and P.travelerActionMask&(select maskBit from InternalAction where name='harnessedJob')!=0;
    </sql:query>
    <c:if test="${empty activityQ.rows}">
        <c:set var="allOk" value="false"/>
        <c:set var="message" value="No Record found."/> 
    </c:if>
    <c:if test="${allOk && empty activityQ.rows[0].begin}">
        <c:set var="allOk" value="false"/>
        <c:set var="message" value="Job not started."/>        
    </c:if>
</c:if>

<c:if test="${allOk}">
    <sql:query var="stepQ" >
        select id from JobHarnessStep where name=?<sql:param value="${inputs.step}"/>
    </sql:query>
    <c:if test="${empty stepQ.rows}">
        <c:set var="allOk" value="false"/>
        <c:set var="message" value="Bad Step."/>
    </c:if>
</c:if>

<c:if test="${allOk}">
    <c:catch var="updateErr">
        <sql:update >
            insert into JobStepHistory set
            jobHarnessStepId=(select id from JobHarnessStep where name=?<sql:param value="${inputs.step}"/>),
            activityId=?<sql:param value="${inputs.jobid}"/>,
            errorString=?<sql:param value="${inputs.status}"/>,
            createdBy=?<sql:param value="${userName}"/>,
            creationTS=UTC_TIMESTAMP();
        </sql:update>
    </c:catch>
    <c:if test="${not empty updateErr}">
        <c:set var="allOk" value="false"/>
        <c:set var="message" value="Update Failure."/>
    </c:if>
</c:if>
<c:choose>
    <c:when test="${allOk}">
        {
            "acknowledge": null
        }
    </c:when>
    <c:otherwise>
        {
            "acknowledge": "${message}"
        }
        <c:if test="${empty inputs.status}">
            <ta:stopTraveler activityId="${inputs.jobid}" mask="15"
                            reason="${message}" travelerId="${travelerId}"/>
        </c:if>
    </c:otherwise>
</c:choose>
<c:if test="${! empty inputs.status}">
   <ta:stopTraveler activityId="${inputs.jobid}" mask="15"
         reason="Job Harness failure" travelerId="${travelerId}"/>
</c:if>
