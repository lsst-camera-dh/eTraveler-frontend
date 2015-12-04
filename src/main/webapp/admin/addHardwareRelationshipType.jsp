<%-- 
    Document   : addHardwareRelationshipType
    Created on : Oct 3, 2013, 3:19:15 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add HardwareRelationshipType</title>
    </head>
    <body>
        <sql:transaction>
            <ta:createRelationshipType slotNames="${param.slotNames}" minorTypeId="${param.minorTypeId}"
                numItems="${param.numItems}" name="${param.name}" hardwareTypeId="${param.hardwareTypeId}"
                description="${param.description}"/>
        </sql:transaction>
        <c:redirect url="${param.referringPage}"/>
    </body>
</html>
