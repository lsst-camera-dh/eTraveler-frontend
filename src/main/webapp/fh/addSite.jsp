<%-- 
    Document   : addSite
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
        <title>Add Site</title>
    </head>
    <body>
        <sql:update >
            insert into Site set
            name=?<sql:param value="${param.name}"/>,
            <c:if test="${! empty param.jhVirtualEnv}">jhVirtualEnv=?<sql:param value="${param.jhVirtualEnv}"/>,</c:if>
            <c:if test="${! empty param.jhOutputRoot}">jhOutputRoot=?<sql:param value="${param.jhOutputRoot}"/>,</c:if>
            createdBy=?<sql:param value="${userName}"/>,
            creationTS=UTC_TIMESTAMP();
        </sql:update>
        <c:redirect url="${header.referer}"/>
    </body>
</html>
