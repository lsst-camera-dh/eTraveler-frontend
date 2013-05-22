<%-- 
    Document   : processPane
    Created on : May 21, 2013, 12:42:51 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Process <c:out value="${param.processId}"/></title>
    </head>
    <body>
        <sql:query var="processQ" dataSource="jdbc/rd-lsst-cam">
            select concat(P.name, ' v', P.version) as processName
            from Process P
            where P.id=?<sql:param value="${param.processId}"/>;
        </sql:query>
        <c:set var="process" value="${processQ.rows[0]}"/>
          
        <h2><c:out value="${process.processName}"/></h2>
        <traveler:processWidget processId="${param.processId}"/>
    </body>
</html>
