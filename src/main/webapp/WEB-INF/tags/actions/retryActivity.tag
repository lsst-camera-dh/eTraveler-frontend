<%-- 
    Document   : retryActivity
    Created on : Feb 20,2014 15:19 PST
    Author     : focke
--%>

<%@tag description="Try an Activity again" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
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

<ta:setActivityStatus activityId="${activityId}" status="superseded"/>

<sql:query var="activityQ" >
    select A.*
    from Activity A
    where A.id=?<sql:param value="${activityId}"/>;
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<ta:createActivity var="newActivityId"
    hardwareId="${activity.hardwareId}"
    processId="${activity.processId}"
    processEdgeId="${activity.processEdgeId}"
    parentActivityId="${activity.parentActivityId}"
    iteration="${activity.iteration + 1}"
    inNCR="${activity.inNCR}"
/>

<traveler:findTraveler var="travelerId" activityId="${activityId}"/>
<traveler:isStopped var="isStopped" activityId="${travelerId}"/>
<c:if test="${isStopped}">
    <ta:resumeActivity activityId="${travelerId}"/>
</c:if>
