<%-- 
    Document   : retryActivity
    Created on : Feb 20,2014 15:19 PST
    Author     : focke
--%>

<%@tag description="Try an Activity again" pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="activityId" required="true"%>

<sql:update>
    update StopWorkHistory set
    resolutionTS=utc_timestamp(),
    resolvedBy=?<sql:param value="${userName}"/>,
    resolution='QUIT'
    where 
    activityId=?<sql:param value="${activityId}"/>
    and
    resolutionTS is null;
</sql:update>

<sql:update >
    update Activity set
    activityFinalStatusId=(select id from ActivityFinalStatus where name='superseded'),
    begin=if(begin is null, utc_timestamp(), begin),
    end=UTC_TIMESTAMP(),
    closedBy=?<sql:param value="${userName}"/>
    where id=?<sql:param value="${activityId}"/>;
</sql:update>

<sql:query var="activityQ" >
    select A.*
    from Activity A
    where A.id=?<sql:param value="${activityId}"/>;
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<sql:update>
    insert into Activity set
    hardwareId=?<sql:param value="${activity.hardwareId}"/>,
    hardwareRelationshipId=?<sql:param value="${activity.hardwareRelationshipId}"/>,
    processId=?<sql:param value="${activity.processId}"/>,
    processEdgeId=?<sql:param value="${activity.processEdgeId}"/>,
    parentActivityId=?<sql:param value="${activity.parentActivityId}"/>,
    iteration=?<sql:param value="${activity.iteration + 1}"/>,
    inNCR=?<sql:param value="${activity.inNCR}"/>,
    createdBy=?<sql:param value="${userName}"/>,
    creationTS=UTC_TIMESTAMP();
</sql:update>

<traveler:findTraveler var="travelerId" activityId="${activityId}"/>
<traveler:isStopped var="isStopped" activityId="${travelerId}"/>
<c:if test="${isStopped}">
    <ta:resumeActivity activityId="${travelerId}"/>
</c:if>
