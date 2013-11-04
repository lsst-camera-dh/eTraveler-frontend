<%-- 
    Document   : limsRequestId
    Created on : Nov 1, 2013, 4:36:11 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>


<c:set var="allOk" value="true"/>
<%-- check hardware id --%>
<%-- get prereqs, return them --%>
<c:if test="${allOk}">
    <sql:query var="prereqQ" dataSource="jdbc/rd-lsst-cam">
        select A.id as activityId, A.hardwareId, A.createdBy, HT.name as hardwareName, P.name as processName, P.userVersionString
        from
        Prerequisite PQ
        inner join Activity A on A.id=PQ.prerequisiteActivityId
        inner join Process P on P.id=A.processId
        inner join HardwareType HT on HT.id=P.hardwareTypeId
        where
        PQ.activityId=?<sql:param value="${inputs.jobid}"/>
    </sql:query>
</c:if>

<c:choose>
    <c:when test="${allOk}">
        {
            "jobid": "${inputs.jobid}",
            "prereq": [
            <c:forEach var="prereqRow" items="${prereqQ.rows}" varStatus="status">
                {
                    "jobid": "${prereqRow.activityId}",
                    "unit_type": "${prereqRow.hardwareName}",
                    "unit_id": "${prereqRow.hardwareId}",
                    "job": "${prereqRow.processName}",
                    "version": "${prereqRow.userVersionString}",
                    "operator": "${prereqRow.createdBy}"
                }
                <c:if test="${! status.last}">,</c:if>
            </c:forEach>
            ]
        }
    </c:when>
    <c:otherwise>
        {
            "jobid": null,
            "error": "requestID doesn't work yet."
        }
    </c:otherwise>
</c:choose>