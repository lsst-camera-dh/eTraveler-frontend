<%-- 
    Document   : stopTraveler
    Created on : Apr 23, 2014, 1:55:38 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Stop Traveler</title>
    </head>
    <body>
        <traveler:findTraveler var="travelerId" activityId="${param.activityId}"/>
        <%-- TODO: Make an entry in StopWorkHistory --%>
        <traveler:failActivity activityId="${param.activityId}" status="${param.status}"/>
        <traveler:redirDA activityId="${travelerId}"/>
    </body>
</html>
