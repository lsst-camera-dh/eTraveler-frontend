<%-- 
    Document   : addIdentifier
    Created on : Jan 15, 2013, 1:47:57 PM
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

        <sql:update >
            insert into HardwareIdentifier set
            authorityId=?<sql:param value="${param.authId}"/>,
            hardwareId=?<sql:param value="${param.hardwareId}"/>,
            hardwareTypeId=?<sql:param value="${param.hardwareTypeId}"/>,
            identifier=?<sql:param value="${param.identifier}"/>,
            createdBy=?<sql:param value="${userName}"/>,
            creationTS=UTC_TIMESTAMP();
        </sql:update>
<%--            
        <c:redirect url="displayHardware.jsp">
            <c:param name="hardwareId" value="${param['hardwareId']}"/>
        </c:redirect>
--%>
        <c:redirect url="${header.referer}"/>
    </body>
</html>
