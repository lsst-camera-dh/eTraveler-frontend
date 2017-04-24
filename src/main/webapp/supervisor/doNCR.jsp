<%-- 
    Document   : doNCR
    Created on : Jun 23, 2014, 10:52:57 AM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Do NCR</title>
    </head>
    <body>
<traveler:checkFreshness formToken="${param.freshnessToken}"/>

<sql:transaction>
    <traveler:getActivityStatus var="activityStatus" varFinal="isFinal" activityId="${param.activityId}"/>
    <c:if test="${activityStatus != 'stopped'}">
        <ta:stopTraveler activityId="${param.activityId}" mask="15" reason="NCR"/>
    </c:if>

    <c:choose>
        <c:when test="${empty param.exceptionTypeId}">
            <ta:getNCRExceptionType var="exceptionTypeId" activityId="${param.activityId}"/>
        </c:when>
        <c:otherwise>
            <c:set var="exceptionTypeId" value="${param.exceptionTypeId}"/>
        </c:otherwise>
    </c:choose>
    
    <sql:query var="hardwareQ">
select hardwareId from Activity where id=?<sql:param value="${param.activityId}"/>
    </sql:query>

    <sql:query var="travelerQ">
select NCRProcessId from ExceptionType where id=?<sql:param value="${exceptionTypeId}"/>
    </sql:query>

    <sql:update>
update StopWorkHistory set
    resolutionTS=utc_timestamp(),
    resolvedBy=?<sql:param value="${userName}"/>,
    resolution='QUIT'
where 
    activityId=?<sql:param value="${param.activityId}"/>
    and
    resolutionTS is null;
    </sql:update>

    <ta:createTraveler var="NCRActivityId"
        hardwareId="${hardwareQ.rows[0].hardwareId}" 
        processId="${travelerQ.rows[0].NCRProcessId}"
        exceptionTypeId="${exceptionTypeId}"
        exitActivityId="${param.activityId}"/>

    <ta:ncrExitActivity activityId="${param.activityId}"/>
</sql:transaction>

    <traveler:redirDA activityId="${NCRActivityId}"/>
    </body>
</html>
