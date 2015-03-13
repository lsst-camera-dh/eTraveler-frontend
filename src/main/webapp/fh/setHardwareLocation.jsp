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
        <title>Set Hardware Location</title>
    </head>
    <body>
        <c:set var="allOk" value="true"/>
        
        <c:if test="${allOk}">
            <c:if test="${empty param.newLocationId}">
                <c:set var="allOk" value="false"/>
                <c:set var="message" value="Go back and select a location."/>
            </c:if>
        </c:if>
        
        <c:if test="${allOk}">
            <sql:query var="locQ">
                select locationId 
                from HardwareLocationHistory 
                where hardwareId=?<sql:param value="${param.hardwareId}"/>
                order by creationTS desc limit 1;
            </sql:query>
            <c:if test="${! empty locQ.rows}">
                <c:if test="${param.newLocationId == locQ.rows[0].locationId}">
                    <c:set var="allOk" value="false"/>
                    <c:set var="message" value="You can't move component to where it already is."/>
                </c:if>
            </c:if>
        </c:if>
        
        <c:if test="${allOk}">
            <sql:query var="parentsQ" >
                select * from HardwareRelationship 
                where componentId=?<sql:param value="${param.hardwareId}"/>
                and end is null;
            </sql:query>
            <c:if test="${! empty parentsQ.rows}">
                <c:set var="allOk" value="false"/>
                <c:url value="displayHardware.jsp" var="parentLink">
                    <c:param name="hardwareId" value="${parentsQ.rows[0].hardwareId}"/>
                </c:url>
                <c:set var="message" value="Sorry, this item cannot be moved because it is part of <a href='${parentLink}'>this</a>."/>
            </c:if>
        </c:if>
                
        <c:choose>
            <c:when test="${allOk}">
                <traveler:setHardwareLocation hardwareId="${param.hardwareId}" newLocationId="${param.newLocationId}"/>
                <c:redirect url="${header.referer}"/>
            </c:when>
            <c:otherwise>
                ${message}
            </c:otherwise>
        </c:choose>
    </body>
</html>
