<%-- 
    Document   : addLocation
    Created on : Oct 3, 2013, 3:19:15 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <sql:update >
            insert into HardwareType set
            name=?<sql:param value="${param.name}"/>,
            autoSequenceWidth=?<sql:param value="${param.width}"/>,
            description=?<sql:param value="${param.description}"/>,
            createdBy=?<sql:param value="${userName}"/>,
            creationTS=NOW();
        </sql:update>
        <c:redirect url="${header.referer}"/>
    </body>
</html>
