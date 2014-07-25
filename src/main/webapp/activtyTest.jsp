<%-- 
    Document   : activityTest
    Created on : Jul 24, 2014, 12:01:35 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Activity Test</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <traveler:activityStepList activityId="${param.activityId}"/>
        <display:table name="${stepList}" class="datatable">
            <display:column property="activityId"/>
            <display:column property="step"/>
            <display:column property="name"/>
        </display:table>
    </body>
</html>
