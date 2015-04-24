<%-- 
    Document   : fail
    Created on : Nov 13, 2013, 12:00:53 PM
    Author     : focke
--%>

<%@tag description="Fail an Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="status"%>

<c:if test="${empty status}">
    <c:set var="status" value="failure"/>
</c:if>

<sql:query var="activityQ">
    select A.*, P.maxIteration
    from Activity A
    inner join Process P on P.id=A.processId
    where A.id=?<sql:param value="${activityId}"/>
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>
    
<c:choose>
    <c:when test="${status == 'failure' && activity.iteration < activity.maxIteration}">
        <ta:retryActivity activityId="${activityId}"/>
    </c:when>
    <c:otherwise>
        <ta:setActivityStatus activityId="${activityId}" status="${status}"/>
        <sql:update>
            update StopWorkHistory set
            resolution='QUIT', resolutionTS=UTC_TIMESTAMP(), resolvedBy=?<sql:param value="${userName}"/>
            where
            activityId=?<sql:param value="${activityId}"/>
            and resolution='NONE' and resolutionTS is null and resolvedBy is null;
        </sql:update>

        <c:if test="${! empty activity.parentActivityId}">
            <ta:failActivity activityId="${activity.parentActivityId}" status="${status}"/>
        </c:if>
    </c:otherwise>
</c:choose>
