<%-- 
    Document   : createHardware
    Created on : Jan 30, 2013, 2:22:04 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Create Hardware</title>
    </head>
    <body>

        <sql:transaction >
            <ta:createHardware hardwareTypeId="${param.hardwareTypeId}" lsstId="${param.lsstId}"
                               quantity="${param.quantity}" manufacturer="${param.manufacturer}"
                               manufacturerId="${param.manufacturerId}" model="${param.model}"
                               manufactureDateStr="${param.manufactureDateDate}" locationId="${param.locationId}"
                               var="hardwareId"/>
        </sql:transaction>
        <c:redirect url="/displayHardware.jsp" context="/eTraveler">
            <c:param name="hardwareId" value="${hardwareId}"/>
        </c:redirect>
    </body>
</html>
