<%-- 
    Document   : repeatActivity
    Created on : Feb 20, 2014 15:15 PST
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Repeat Activity</title>
    </head>
    <body>
<traveler:checkFreshness formToken="${param.freshnessToken}"/>        

<sql:transaction>
        <ta:repeatActivity activityId="${param.activityId}"/>
</sql:transaction>
        <traveler:redirDA/>
    </body>
</html>
