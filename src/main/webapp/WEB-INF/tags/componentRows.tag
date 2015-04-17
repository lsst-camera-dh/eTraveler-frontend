<%-- 
    Document   : compOfRows
    Created on : Apr 9, 2013, 2:01:16 PM
    Author     : focke
--%>

<%@tag description="Put rows in componentTable" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="hardwareId" required="true"%>
<%@attribute name="mode" required="true"%><%-- "p" for parents, "c" for children --%>
<%@attribute name="depth" required="true"%>

<c:choose>
    <c:when test="${mode=='c'}">
        <c:set var="me" value="hardwareId"/>
        <c:set var="you" value="componentId"/>
    </c:when>
    <c:when test="${mode=='p'}">
        <c:set var="me" value="componentId"/>
        <c:set var="you" value="hardwareId"/>
    </c:when>
    <c:otherwise>
        <c:set var="me" value="tarzan"/>
        <c:set var="you" value="jane"/>        
    </c:otherwise>
</c:choose>

<c:set var="newDepth" value="${depth - 1}"/>

<sql:query var="componentsQ" >
    select 
    HR.${you} as itemId, HR.begin, HR.end, 
    HRT.name as relationshipName, 
    HT.name as hardwareName, HT.id as hardwareTypeId, 
    H.lsstId
    from HardwareRelationship HR
    inner join HardwareRelationshipType HRT on HRT.id=HR.hardwareRelationshipTypeId
    inner join Hardware H on H.id=HR.${you}
    inner join HardwareType HT on HT.id=H.hardwareTypeId
    where 
    HR.${me}=?<sql:param value="${hardwareId}"/>
    and 
    HR.end is null;
</sql:query>

<c:forEach var="cRow" items="${componentsQ.rows}">
    <c:set var="cRowJsp" value="${cRow}" scope="request"/>
    <%
        ((java.util.List)request.getAttribute("components")).add(request.getAttribute("cRowJsp"));
    %>
    <c:if test="${newDepth > 0}">
        <traveler:componentRows hardwareId="${cRow.itemId}" mode="${mode}" depth="${newDepth}"/>
    </c:if>
</c:forEach>