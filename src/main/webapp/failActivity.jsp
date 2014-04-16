<%-- 
    Document   : failActivity
    Created on : Apr 16, 2014, 1:10:36 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Fail Activity</title>
    </head>
    <body>
        <traveler:failActivity activityId="${param.activityId}" status="${param.status}"/>
        <traveler:redirDA/>
    </body>
</html>
