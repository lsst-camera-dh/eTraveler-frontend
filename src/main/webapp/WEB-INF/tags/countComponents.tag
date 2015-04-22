<%-- 
    Document   : countConponents
    Created on : Apr 10, 2015, 4:56:40 PM
    Author     : focke
--%>

<%@tag description="Count the components in an assembly and its children" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="hardwareId" required="true"%>
<%@attribute name="top"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="nComps" scope="AT_BEGIN"%>

<c:if test="${empty top}">
    <c:set var="top" value="true"/>
</c:if>

<c:choose>
    <c:when test="${top}">
        <c:set var="nComps" value="0"/>
    </c:when>
    <c:otherwise>
        <c:set var="nComps" value="1"/>
    </c:otherwise>
</c:choose>

<sql:query var="childrenQ" >
    select 
    HR.componentId
    from HardwareRelationship HR
    where HR.hardwareId=?<sql:param value="${hardwareId}"/>
    and end is null
    ;
</sql:query>

<c:forEach var="cRow" items="${childrenQ.rows}">
    <traveler:countComponents var="cComps" hardwareId="${cRow.componentId}" top="false"/>
    <c:set var="nComps" value="${nComps + cComps}"/>
</c:forEach>
