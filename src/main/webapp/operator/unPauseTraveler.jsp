<%-- 
    Document   : unPauseTraveler
    Created on : Apr 29, 2015, 6:08:24 PM
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
        <title>Unpause Traveler</title>
    </head>
    <body>
<traveler:checkFreshness formToken="${param.freshnessToken}"/>        

<traveler:findTraveler var="travelerId" activityId="${param.activityId}"/>

<sql:transaction>
    <ta:resumeActivity activityId="${travelerId}"/>
</sql:transaction>

<traveler:redirDA activityId="${travelerId}"/>
    </body>
</html>
