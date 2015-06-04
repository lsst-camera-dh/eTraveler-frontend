<%-- 
    Document   : skipStep
    Created on : Apr 8, 2015, 2:34:20 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Skip a step</title>
    </head>
    <body>
        <sql:transaction>
            <traveler:findTraveler var="travelerId" activityId="${param.activityId}"/>
            <ta:resumeActivity activityId="${travelerId}"/>
            <ta:skipStep activityId="${param.activityId}"/>
        </sql:transaction>
        <traveler:redirDA/>
    </body>
</html>
