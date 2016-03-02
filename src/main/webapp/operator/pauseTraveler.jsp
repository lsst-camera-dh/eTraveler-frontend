<%-- 
    Document   : pauseTraveler
    Created on : Apr 29, 2015, 5:40:03 PM
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
        <title>Pause Traveler</title>
    </head>
    <body>
<traveler:checkFreshness formToken="${param.freshnessToken}"/>        

<traveler:findTraveler var="travelerId" activityId="${param.activityId}"/>

<sql:transaction>
    <ta:stopActivity activityId="${travelerId}" status="paused"/>
</sql:transaction>

<traveler:redirDA activityId="${travelerId}"/>

    </body>
</html>
