<%-- 
    Document   : fakeLimsBack
    Created on : Oct 2, 2013, 2:40:55 PM
    Author     : focke
--%>

<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="com.fasterxml.jackson.databind.ObjectMapper,com.fasterxml.jackson.core.JsonParser,java.util.Map"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="lims" tagdir="/WEB-INF/tags/lims"%>

<c:set var="allOk" value="true"/>

<%
    ObjectMapper mapper = new ObjectMapper();
    mapper.configure(JsonParser.Feature.ALLOW_NON_NUMERIC_NUMBERS, true);
    String jo = session.getAttribute("jsonObject").toString();
    Map<String, Object> inputs = mapper.readValue(jo, Map.class);
    request.setAttribute("inputs", inputs);
%>

<%-- if job-specific: check if jobid matches an active JH Activity --%>
<c:if test="${allOk && (command == 'update' || command == 'ingest' || command == 'status')}">
    <sql:query var="creatorQ">
        select createdBy from Activity where id=?<sql:param value="${inputs.jobid}"/>
    </sql:query>
    <c:if test="${empty creatorQ.rows}">
        <c:set var="allOk" value="false"/>
        <c:set var="message" value="Bad jobid."/>
    </c:if>

    <c:if test="${allOk && empty userName}">
        <c:set var="userName" value="${creatorQ.rows[0].createdBy}" scope="session"/>
    </c:if>
</c:if>
        
<c:if test="${empty userName}">
    <c:set var="userName" value="${inputs.operator}" scope="session"/>
</c:if>

<c:if test="${allOk}">
<sql:transaction>
<c:choose>
    <c:when test="${command == 'requestID'}">
        <lims:requestId/>
    </c:when>
    <c:when test="${command == 'update'}">
        <lims:update/>
    </c:when>
    <c:when test="${command == 'ingest'}">
        <lims:ingest/>
    </c:when>
    <c:when test="${command == 'nextJob'}">
        <lims:script/>
    </c:when>
    <c:when test="${command == 'registerHardware'}">
        <lims:registerHardware/>
    </c:when>
    <c:when test="${command == 'defineHardwareType'}">
        <lims:defineHardwareType/>
    </c:when>
    <c:when test="${command == 'runAutomatable'}">
        <lims:runAutomatable/>
    </c:when>
    <c:when test="${command == 'runOneStep'}">
        <lims:oneStep/>
    </c:when>
    <c:when test="${command == 'status'}">
        <c:set var="allOk" value="false"/>
        <c:set var="message" value="status doesn't work yet."/>
    </c:when>
    <c:otherwise>
        <c:set var="allOk" value="false"/>
        <c:set var="message" value="Bad command"/>
    </c:otherwise>
</c:choose>
</sql:transaction>
</c:if>
        
<c:if test="${! allOk}">
    {
        "error": "${message}",
        "acknowledge": "${message}"
    }
</c:if>
