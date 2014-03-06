<%-- 
    Document   : fakeLims
    Created on : Oct 2, 2013, 2:40:55 PM
    Author     : focke
--%>

<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="com.fasterxml.jackson.databind.ObjectMapper,java.util.Map"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%
    ObjectMapper mapper = new ObjectMapper();
    Map<String, Object> inputs = mapper.readValue(request.getParameter("jsonObject"), Map.class);
    request.setAttribute("inputs", inputs);
%>

<%-- for all but requestId: check if jobid matches an active JH Activity --%>

<c:set var="allOk" value="true"/>

<%-- pick DB --%>
<c:choose>
    <c:when test="${fn:contains(pageContext.request.requestURI, '/Dev/')}">
        
    </c:when>
    <c:when test="${fn:contains(pageContext.request.requestURI, '/Prod/')}">
        
    </c:when>
    <c:otherwise>
        <c:set var="allOk" value="false"/>
        <c:set var="message" value="Bad URL"/>
    </c:otherwise>
</c:choose>

<c:if test="${allOk}">
<c:choose>
    <c:when test="${fn:endsWith(pageContext.request.requestURI, '/requestID')}">
        <traveler:limsRequestId/>
    </c:when>
    <c:when test="${fn:endsWith(pageContext.request.requestURI, '/update')}">
        <traveler:limsUpdate/>
    </c:when>
    <c:when test="${fn:endsWith(pageContext.request.requestURI, '/ingest')}">
        <traveler:limsIngest/>
    </c:when>
    <c:when test="${fn:endsWith(pageContext.request.requestURI, '/status')}">
        <c:set var="allOk" value="false"/>
        <c:set var="message" value="status doesn't work yet."/>
    </c:when>
    <c:otherwise>
        <c:set var="allOk" value="false"/>
        <c:set var="message" value="Bad command"/>
    </c:otherwise>
</c:choose>
</c:if>
        
<c:if test="${! allOk}">
    {
        "error": "${message}",
        "acknowledge": "${message}"
    }
</c:if>