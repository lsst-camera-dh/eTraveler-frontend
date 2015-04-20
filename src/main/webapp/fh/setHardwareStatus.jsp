<%-- 
    Document   : setHardwareStatus
    Created on : Jun 27, 2013, 2:44:09 PM
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
        <title>Set Hardware Status</title>
    </head>
    <body>
        <c:set var="allOk" value="true"/>
        
        <c:if test="${allOk}">
            <c:if test="${empty param.hardwareId}">
                <c:set var="allOk" value="false"/>
                <c:set var="message" value="You must specifiy which component to operate on."/>
            </c:if>
        </c:if>
        
        <c:if test="${allOk}">
            <c:if test="${empty param.hardwareStatusId}">
                <c:set var="allOk" value="false"/>
                <c:set var="message" value="You must specifiy a new component status."/>
            </c:if>
        </c:if>
        
        <c:if test="${allOk}">
            <sql:query var="statusQ">
select hardwareStatusId 
from HardwareStatusHistory 
where hardwareId=?<sql:param value="${param.hardwareId}"/>
order by id desc limit 1;
            </sql:query>
            <c:if test="${statusQ.rows[0].hardwareStatusId == param.hardwareStatusId}">
                <c:set var="allOk" value="false"/>
                <c:set var="message" value="You can't set the status to the same thing it already is."/>
            </c:if>
        </c:if>
        
        <c:choose>
            <c:when test="${allOk}">
<sql:transaction>
                <ta:setHardwareStatus hardwareStatusId="${param.hardwareStatusId}" hardwareId="${param.hardwareId}"/>
</sql:transaction>
                <c:redirect url="${header.referer}"/>
            </c:when>
            <c:otherwise>
                ${message}
            </c:otherwise>
        </c:choose>
</body>
</html>
