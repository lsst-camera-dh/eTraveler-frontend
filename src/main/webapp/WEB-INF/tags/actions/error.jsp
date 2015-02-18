<%-- 
    Document   : error
    Created on : Feb 11, 2015, 4:10:39 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Error Page</title>
    </head>
    <body>
        <h1>Drat!</h1>
        <br>There was a problem:<br>
        <c:out value="${param.message}"/>
    </body>
</html>
