<%-- 
    Document   : retryActivity
    Created on : Feb 20, 2014 15:15 PST
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Retry Activity</title>
    </head>
    <body>

        <traveler:retryActivity activityId="${param.activityId}"/>

        <traveler:redirDA/>
    </body>
</html>
