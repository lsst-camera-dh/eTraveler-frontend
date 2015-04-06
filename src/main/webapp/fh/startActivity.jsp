<%-- 
    Document   : startActivity
    Created on : Aug 1, 2013, 12:11:08 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Start Activity</title>
    </head>
    <body>
        <ta:startActivity activityId="${param.activityId}"/>
        <traveler:redirDA/>
    </body>
</html>
