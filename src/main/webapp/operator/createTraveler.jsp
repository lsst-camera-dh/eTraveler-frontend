<%-- 
    Document   : createTraveler
    Created on : Jan 30, 2013, 2:22:04 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Create Traveler</title>
    </head>
    <body>
        <traveler:checkFreshness formToken="${param.freshnessToken}"/>        
        
        <traveler:checkMask var="mayStart" processId="${param.processId}"/>
        <c:if test="${! mayStart}">
            <traveler:error message="You don't have permission to start this traveler."/>
        </c:if>
        <sql:transaction>
        <ta:createTraveler var="activityId"
            hardwareId="${param.hardwareId}" 
            processId="${param.processId}"
            jobHarnessId="${param.jobHarnessId}"
            inNCR="${param.inNCR}"/>
        </sql:transaction>
        <traveler:redirDA activityId="${activityId}"/>
    </body>
</html>
