<%-- 
    Document   : setSite
    Created on : Apr 2, 2013, 4:15:37 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>JSP Page</title>
    </head>
    <body>
        <c:set var="role" value="${param.role}" scope="session"/>
        <c:redirect url="${header.referer}"/>
    </body>
</html>
