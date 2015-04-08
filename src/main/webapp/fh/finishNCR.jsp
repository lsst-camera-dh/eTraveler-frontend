<%-- 
    Document   : finishNCR
    Created on : Jul 23, 2014, 3:10:46 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>

<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Closeout NCR Activity</title>
    </head>
    <body>

<sql:transaction>
        <ta:finishNCR ncrActivityId="${param.activityId}"
                            varNew="newActivityId"
                            varTrav="travelerId"/>
</sql:transaction>
        <traveler:redirDA activityId="${travelerId}"/>
    </body>
</html>
