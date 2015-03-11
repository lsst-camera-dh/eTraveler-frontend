<%-- 
    Document   : resumeTraveler
    Created on : Apr 17, 2014, 3:34:23 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Restart Traveler</title>
    </head>
    <body>
        <traveler:findTraveler var="travelerId" activityId="${param.activityId}"/>
        <traveler:isStopped var="isStopped" activityId="${travelerId}"/>
        
        <c:choose>
            <c:when test="${isStopped}">
                <sql:update>
                    update StopWorkHistory set
                    resolution='RESUMED',
                    resolutionTS=UTC_TIMESTAMP(),
                    resolvedBy=?<sql:param value="${userName}"/>
                    where
                    rootActivityId=?<sql:param value="${travelerId}"/>
                    and resolutionTS is null;
                </sql:update>
                
                <traveler:resumeActivity activityId="${travelerId}"/>
                <traveler:redirDA activityId="${travelerId}"/>
            </c:when>
            <c:otherwise>
You can't resume a traveler that's not stopped.                
            </c:otherwise>
        </c:choose>
    </body>
</html>
