<%-- 
    Document   : setLocation
    Created on : Sep 24, 2013, 4:48:45 PM
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
        <title>JSP Page</title>
    </head>
    <body>
        <sql:query var="parentsQ" >
            select * from HardwareRelationship 
            where componentId=?<sql:param value="${param.hardwareId}"/>
            and end is null;
        </sql:query>
        <c:choose>
            <c:when test="${! empty parentsQ.rows}">
                <c:url value="displayHardware.jsp" var="parentLink">
                    <c:param name="hardwareId" value="${parentsQ.rows[0].hardwareId}"/>
                </c:url>
                Sorry, this item cannot be moved because it is part of <a href='<c:out value="${parentLink}"/>'>this</a>.
            </c:when>
            <c:otherwise>
                <traveler:setHardwareLocation newLocationId="${param.newLocationId}" hardwareId="${param.hardwareId}"/>
                <c:redirect url="${header.referer}"/>
            </c:otherwise>
        </c:choose>
    </body>
</html>
