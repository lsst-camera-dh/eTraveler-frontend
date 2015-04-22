<%-- 
    Document   : addHardwareIdentifierAuthority
    Created on : Oct 3, 2013, 3:19:15 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add HardwareIdentifierAuthority</title>
    </head>
    <body>
<sql:transaction>
        <sql:update >
            insert into HardwareIdentifierAuthority set
            name=?<sql:param value="${param.name}"/>,
            createdBy=?<sql:param value="${userName}"/>,
            creationTS=UTC_TIMESTAMP();
        </sql:update>
</sql:transaction>
        <c:redirect url="${header.referer}"/>
    </body>
</html>
