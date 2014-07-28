<%-- 
    Document   : fakeLims
    Created on : Oct 2, 2013, 2:40:55 PM
    Author     : focke
--%>

<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<c:set var="allOk" value="true"/>

<c:set var="jsonObject" value="${param.jsonObject}" scope="session"/>

<c:if test="${allOk}">
    <c:choose>
        <c:when test="${fn:contains(pageContext.request.requestURI, '/Prod/')}">
            <c:set var="dataSourceMode" value="Prod"/>
        </c:when>
        <c:when test="${fn:contains(pageContext.request.requestURI, '/Dev/')}">
            <c:set var="dataSourceMode" value="Dev"/>
        </c:when>
        <c:when test="${fn:contains(pageContext.request.requestURI, '/Test/')}">
            <c:set var="dataSourceMode" value="Test"/>
        </c:when>
        <c:when test="${fn:contains(pageContext.request.requestURI, '/Raw/')}">
            <c:set var="dataSourceMode" value="Raw"/>
        </c:when>
        <c:otherwise>
            <c:set var="allOk" value="false"/>
            <c:set var="message" value="Bad URL"/>
        </c:otherwise>
    </c:choose>
</c:if>

<c:if test="${allOk}">
    <c:set var="urlComponents" value="${fn:split(pageContext.request.requestURI, '/')}"/>
    <c:set var="command" value="${urlComponents[fn:length(urlComponents)-1]}" scope="session"/>
<%--    <c:url var="backendUrl" value="/limsBack" context="/">--%>
    <c:url var="backendUrl" value="/fakeLimsBack.jsp" context="/">
        <c:param name="dataSourceMode" value="${dataSourceMode}"/>
    </c:url>
    <c:redirect url="${backendUrl}"/>
</c:if>
        
<c:if test="${! allOk}">
    {
        "error": "${message}",
        "acknowledge": "${message}"
    }
</c:if>
    