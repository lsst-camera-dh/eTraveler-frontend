<%-- 
    Document   : addHardwareRelationshipType
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
        <title>Add HardwareRelationshipType</title>
    </head>
    <body>
        <sql:transaction>
        <sql:update >
            insert into HardwareRelationshipType set
            name=?<sql:param value="${param.name}"/>,
            hardwareTypeId=?<sql:param value="${param.hardwareTypeId}"/>,
            componentTypeId=?<sql:param value="${param.componentTypeId}"/>,
            slot=?<sql:param value="${param.slot}"/>,
            description=?<sql:param value="${param.description}"/>,
            createdBy=?<sql:param value="${userName}"/>,
            creationTS=UTC_TIMESTAMP();
        </sql:update>
        </sql:transaction>
        <c:redirect url="${param.referringPage}"/>
    </body>
</html>
