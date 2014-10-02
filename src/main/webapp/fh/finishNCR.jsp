<%-- 
    Document   : finishNCR
    Created on : Jul 23, 2014, 3:10:46 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Closeout NCR Activity</title>
    </head>
    <body>

        <traveler:finishNCR ncrActivityId="${param.activityId}"
                            varNew="newActivityId"
                            varTrav="travelerId"/>

        <traveler:redirDA activityId="${travelerId}"/>
    </body>
</html>
