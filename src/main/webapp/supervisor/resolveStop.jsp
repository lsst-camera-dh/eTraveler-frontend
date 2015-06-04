<%-- 
    Document   : resolveStop
    Created on : Jun 18, 2014, 2:55:14 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Resolve Stop Work condition</title>
    </head>
    <body>
        <traveler:findTraveler var="travelerId" activityId="${param.activityId}"/>
        <traveler:resolveStop activityId="${param.activityId}" travelerId="${travelerId}"/>
        </body>
</html>
