<%-- 
    Document   : setSite
    Created on : Apr 2, 2013, 4:15:37 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>JSP Page</title>
    </head>
    <body>
        <c:set var="siteId" value="${param.siteId}" scope="session"/>
        <sql:query var="idAuthNameQ" dataSource="jdbc/rd-lsst-cam">
            select name from HardwareIdentifierAuthority where id=?;
            <sql:param value="${param.siteId}"/>
        </sql:query>
        <c:set var="siteName" value="${idAuthNameQ.rows[0]['name']}" scope="session"/>
        <c:redirect url="${header.referer}"/>
    </body>
</html>
