<%-- 
    Document   : restartTraveler
    Created on : Apr 17, 2014, 3:34:23 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Restart Traveler</title>
    </head>
    <body>
        <traveler:restartActivity activityId="${param.activityId}"/>
        <traveler:redirDA/>
    </body>
</html>
