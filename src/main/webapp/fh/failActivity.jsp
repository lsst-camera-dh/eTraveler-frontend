<%-- 
    Document   : failActivity
    Created on : Apr 16, 2014, 1:10:36 PM
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
        <title>Fail Activity</title>
    </head>
    <body>
<sql:transaction>
        <ta:failActivity activityId="${param.activityId}" status="${param.status}"/>
</sql:transaction>
        <traveler:redirDA/>
    </body>
</html>
