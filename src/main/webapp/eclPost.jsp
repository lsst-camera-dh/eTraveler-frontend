<%-- 
    Document   : eclPost
    Created on : Apr 1, 2014, 1:15:34 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="/WEB-INF/eclTagLibrary.tld" prefix="ecl"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
    <h2>Psych, this doesn't actually post yet.</h2>
    
    <c:choose>
        <c:when test="${! empty param.activityId}">
            <c:set var="page" value="displayActivity.jsp"/>
            <c:set var="paramName" value="activityId"/>
            <c:set var="paramValue" value="${param.activityId}"/>
        </c:when>
        <c:when test="${! empty param.processId}">
            <c:set var="page" value="displayProcess.jsp"/>
            <c:set var="paramName" value="processPath"/>
            <c:set var="paramValue" value="${param.processId}"/>
        </c:when>
        <c:when test="${! empty param.hardwareId}">
            <c:set var="page" value="displayHardware.jsp"/>
            <c:set var="paramName" value="hardwareId"/>
            <c:set var="paramValue" value="${param.hardwareId}"/>
        </c:when>
        <c:when test="${! empty param.hardwareTypeId}">
            <c:set var="page" value="displayHardwareType"/>            
            <c:set var="paramName" value="hardwareTypeId"/>
            <c:set var="paramValue" value="${param.hardwareTypeId}"/>
        </c:when>
        <c:otherwise>
            Bug 098653
        </c:otherwise>
    </c:choose>
            
    <c:url var="displayUrl" value="${page}">
        <c:param name="${paramName}" value="${paramValue}"/>
    </c:url>
    <c:set var="displayLink" value="<a href='${displayUrl}'>eTraveler</a>"/>
    <c:set var="text" value="${param.text}<br>${displayLink}"/>
        
    <ecl:eclPost 
        text="${text}" 
        author="${param.author}" 
        hardwareTypeId="${param.hardwareTypeId}" 
        hardwareId="${param.hardwareId}" 
        processId="${param.processId}" 
        activityId="${param.activityId}"
        />
    </body>
</html>
