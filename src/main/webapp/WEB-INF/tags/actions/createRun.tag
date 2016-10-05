<%-- 
    Document   : createRun
    Created on : Sep 28, 2016, 11:56:49 AM
    Author     : focke
--%>

<%@tag description="(maybe) Add a record to RunNumber" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>

    <sql:query var="activityQ">
select A.inNCR
from Activity A
where A.id = ?<sql:param value="${activityId}"/>
    </sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<traveler:findNcrContainingTraveler var="containerId" activityId="${activityId}"/>
<c:choose>
    <c:when test="${(! activity.inNCR) || (empty containerId)}">
        <c:choose>
            <c:when test="${appVariables.dataSourceMode == 'Raw'}">
                <c:set var="extension" value="R"/>
            </c:when>
            <c:when test="${appVariables.dataSourceMode == 'Test'}">
                <c:set var="extension" value="T"/>
            </c:when>
            <c:when test="${appVariables.dataSourceMode == 'Dev'}">
                <c:set var="extension" value="D"/>
            </c:when>
            <c:otherwise>
                <c:set var="extension" value=""/>
            </c:otherwise>
        </c:choose>
        <sql:update>
insert into RunNumber set
rootActivityId = ?<sql:param value="${activityId}"/>,
createdBy = ?<sql:param value="${userName}"/>,
creationTS = utc_timestamp();
        </sql:update>
        <sql:update>
update RunNumber set
runNumber = concat(last_insert_id(), ?<sql:param value="${extension}"/>),
runInt = last_insert_id()
where id = last_insert_id();
        </sql:update>
    </c:when>
    <c:otherwise>
        <sql:query var="containerQ">
select runNumber, runInt from RunNumber where rootActivityId = ?<sql:param value="${containerId}"/>;
        </sql:query>
        <c:set var="container" value="${containerQ.rows[0]}"/>
        <sql:update>
insert into RunNumber set
rootActivityId = ?<sql:param value="${activityId}"/>,
runNumber = ?<sql:param value="${container.runNumber}"/>,
runInt = ?<sql:param value="${container.runInt}"/>,
createdBy = ?<sql:param value="${userName}"/>,
creationTS = utc_timestamp();
        </sql:update>
    </c:otherwise>
</c:choose>
