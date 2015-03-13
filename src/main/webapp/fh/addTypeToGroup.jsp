<%-- 
    Document   : addTypeToGroup
    Created on : Mar 13, 2015, 1:29:04 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add HardwareType to HardwareGroup</title>
    </head>
    <body>
        <sql:update>
            insert into HardwareTypeGroupMapping set
            hardwareGroupId=?<sql:param value="${param.hardwareGroupId}"/>,
            hardwareTypeId=?<sql:param value="${param.hardwareTypeId}"/>,
            createdBy=?<sql:param value="${userName}"/>,
            creationTS=UTC_TIMESTAMP();
        </sql:update>
        <c:redirect url="${header.referer}"/>
    </body>
</html>
