<%-- 
    Document   : eclWidget
    Created on : Apr 1, 2014, 3:03:22 PM
    Author     : focke
--%>

<%@tag description="eLog stuff" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="author" required="true"%>
<%@attribute name="hardwareTypeId" required="true"%>
<%@attribute name="hardwareId"%>
<%@attribute name="processId"%>
<%@attribute name="activityId"%>

<h2>Electronic Logbook</h2>

<c:set var="version" value="${appVariables.etravelerELogVersion}"/>
<c:set var="eLogHome" value="${appVariables.etravelerELogUrl}"/>
<c:set var="eLogSearchPath" value="E/search"/>

<c:set var="activityField" value="activityId${! empty activityId ? activityId : 0}"/>
<c:set var="processField" value="processId${! empty processId ? processId : 0}"/>
<c:set var="hardwareField" value="hardwareId${! empty hardwareId ? hardwareId : 0}"/>
<c:set var="hardwareTypeField" value="hardwareTypeId${! empty hardwareTypeId ? hardwareTypeId : 0}"/>

<c:choose>
    <c:when test="${! empty param.activityId}">
        <c:set var="page" value="displayActivity.jsp"/>
        <c:set var="paramName" value="activityId"/>
        <c:set var="paramValue" value="${param.activityId}"/>
        <c:set var="searchField" value="${activityField}"/>
    </c:when>
    <c:when test="${! empty param.processId}">
        <c:set var="page" value="displayProcess.jsp"/>
        <c:set var="paramName" value="processPath"/>
        <c:set var="paramValue" value="${param.processId}"/>
        <c:set var="searchField" value="${processField}"/>
    </c:when>
    <c:when test="${! empty param.hardwareId}">
        <c:set var="page" value="displayHardware.jsp"/>
        <c:set var="paramName" value="hardwareId"/>
        <c:set var="paramValue" value="${param.hardwareId}"/>
        <c:set var="searchField" value="${hardwareField}"/>
   </c:when>
    <c:when test="${! empty param.hardwareTypeId}">
        <c:set var="page" value="displayHardwareType.jsp"/>            
        <c:set var="paramName" value="hardwareTypeId"/>
        <c:set var="paramValue" value="${param.hardwareTypeId}"/>
        <c:set var="searchField" value="${hardwareTypeField}"/>
    </c:when>
    <c:otherwise>
        <traveler:error message="Bug 098653" bug="true"/>
    </c:otherwise>
</c:choose>

<traveler:fullContext var="fullContext"/>
<c:url var="displayUrl" value="${fullContext}/${page}">
    <c:param name="${paramName}" value="${paramValue}"/>
    <c:param name="dataSourceMode" value="${appVariables.dataSourceMode}"/>
</c:url>
<c:set var="displayLink" value="<a href='${displayUrl}' target='_blank'>eTraveler</a>"/>

<table border="1">
    <tr>
        <td>
<c:url var="searchLink" value="${eLogHome}/${eLogSearchPath}">
    <c:param name="text" value="${searchField}"/>
</c:url>
<a href="${searchLink}" target="_blank">Search eLog</a>
        </td>
    </tr>
    <tr>
        <td>
<form method="GET" action="fh/eclPost.jsp">
    <input type="hidden" name="displayLink" value="${displayLink}">
    <input type="hidden" name="author" value="${author}">
    <input type="hidden" name="hardwareTypeId" value="${hardwareTypeField}">
    <input type="hidden" name="hardwareId" value="${hardwareField}">
    <input type="hidden" name="processId" value="${processField}">
    <input type="hidden" name="activityId" value="${activityField}">
    <input type="hidden" name="version" value="${version}">
    <textarea name="text"></textarea>
    <input type="SUBMIT" value="Post a comment">
</form>
        </td>
    </tr>
</table>