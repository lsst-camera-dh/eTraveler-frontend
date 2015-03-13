<%-- 
    Document   : fakeLimsBack
    Created on : Oct 2, 2013, 2:40:55 PM
    Author     : focke
--%>

<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="com.fasterxml.jackson.databind.ObjectMapper,java.util.Map"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<c:set var="allOk" value="true"/>

<%
    ObjectMapper mapper = new ObjectMapper();
    String jo = session.getAttribute("jsonObject").toString();
    Map<String, Object> inputs = mapper.readValue(jo, Map.class);
    request.setAttribute("inputs", inputs);
%>

<%-- for all but requestId or nextCommand: check if jobid matches an active JH Activity --%>
<c:if test="${allOk && command != 'requestID' && command != 'nextJob'}">
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

<c:if test="${allOk}">
<c:choose>
    <c:when test="${command == 'requestID'}">
        <traveler:limsRequestId/>
    </c:when>
    <c:when test="${command == 'update'}">
        <traveler:limsUpdate/>
    </c:when>
    <c:when test="${command == 'ingest'}">
        <traveler:limsIngest/>
    </c:when>
    <c:when test="${command == 'nextJob'}">
        <c:set var="userName" value="${inputs.operator}" scope="session"/>
        <traveler:limsScript/>
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
</c:if>
        
<c:if test="${! allOk}">
    {
        "error": "${message}",
        "acknowledge": "${message}"
    }
</c:if>