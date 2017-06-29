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

<%
    ObjectMapper mapper = new ObjectMapper();
    mapper.configure(JsonParser.Feature.ALLOW_NON_NUMERIC_NUMBERS, true);
    String jo = session.getAttribute("jsonObject").toString();
    Map<String, Object> inputs = mapper.readValue(jo, Map.class);
    request.setAttribute("inputs", inputs);
%>

<%-- if job-specific: check if jobid matches an active JH Activity --%>
<c:if test="${command == 'update' || command == 'ingest' || command == 'status'}">
    <sql:query var="creatorQ">
        select createdBy from Activity where id=?<sql:param value="${inputs.jobid}"/>
    </sql:query>
    <c:if test="${empty creatorQ.rows}">
        <traveler:error message="Bad jobid."/>
    </c:if>

    <c:if test="${empty userName}">
        <c:set var="userName" value="${creatorQ.rows[0].createdBy}" scope="session"/>
    </c:if>
</c:if>
        
<c:if test="${empty userName}">
    <lims:checkUser var="isMagic"/>
    <c:set var="userName" value="${isMagic ? 'API' : inputs.operator}" scope="session"/>
</c:if>

<sql:transaction>
<c:choose>
    <%-- job harness --%>
    <c:when test="${command == 'requestID'}">
        <lims:requestId/>
    </c:when>
    <c:when test="${command == 'update'}">
        <lims:update/>
    </c:when>
    <c:when test="${command == 'ingest'}">
        <lims:ingest/>
    </c:when>
    <%-- scripting --%>
    <c:when test="${command == 'nextJob'}">
        <lims:script/>
    </c:when>
    <c:when test="${command == 'runAutomatable'}">
        <lims:runAutomatable/>
    </c:when>
    <c:when test="${command == 'runOneStep'}">
        <lims:oneStep/>
    </c:when>
    <%-- client --%>
    <c:when test="${command == 'registerHardware'}">
        <lims:checkPerm/>
        <lims:registerHardware/>
    </c:when>
    <c:when test="${command == 'defineHardwareType'}">
        <lims:checkPerm/>
        <lims:defineHardwareType/>
    </c:when>
    <c:when test="${command == 'defineRelationshipType'}">
        <lims:checkPerm/>
        <lims:defineRelationshipType/>
    </c:when>
    <c:when test="${command == 'uploadYaml'}">
        <lims:checkPerm/>
        <lims:upload/>
    </c:when>
    <c:when test="${command == 'setHardwareStatus'}">
        <lims:checkPerm/>
        <lims:setHardwareStatus/>
    </c:when>
    <c:when test="${command == 'modifyLabels'}">
        <lims:checkPerm/>
        <lims:modifyLabels/>
    </c:when>
    <c:when test="${command == 'setHardwareLocation'}">
        <lims:checkPerm/>
        <lims:setHardwareLocation/>
    </c:when>
    <c:when test="${command == 'setManufacturerId'}">
        <lims:checkPerm/>
        <lims:setManufacturerId/>
    </c:when>
    <c:when test="${command == 'getManufacturerId'}">
        <lims:getManufacturerId/>
    </c:when>
    <c:when test="${command == 'getResults'}">
        <lims:getResults />
    </c:when>	    
    <c:when test="${command == 'getHardwareHierarchy'}">
        <lims:getHardwareHierarchy/>
    </c:when>
    <c:when test="${command == 'getContainingHardware'}">
        <lims:getHardwareParents/>
    </c:when>
    <c:when test="${command == 'getRunInfo'}">
        <lims:getRunInfo/>
    </c:when>
    <%-- unimplemented JH --%>
    <c:when test="${command == 'status'}">
        <traveler:error message="status doesn't work yet."/>
    </c:when>
    <c:otherwise>
        <traveler:error message="Bad command"/>
    </c:otherwise>
</c:choose>
</sql:transaction>
