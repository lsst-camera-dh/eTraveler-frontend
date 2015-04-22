<%-- 
    Document   : componentTable
    Created on : Apr 9, 2013, 1:55:08 PM
    Author     : focke
--%>

<%@tag description="Make a table showing components of an assembly, or the chain of assemblies that a component is in" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="hardwareId" required="true"%>
<%@attribute name="mode" required="true"%>

<c:choose>
    <c:when test="${'p' == mode}">
        <c:set var="depth" value="${preferences.componentHeight}"/>
    </c:when>
    <c:when test="${'c' == mode}">
        <c:set var="depth" value="${preferences.componentDepth}"/>
    </c:when>
    <c:otherwise>
        <traveler:error message="Bug 785218: Bad component list mode."/>
    </c:otherwise>
</c:choose>

<%
    java.util.List components = new java.util.LinkedList();
    request.setAttribute("components", components);
%>
<c:if test="${depth > 0}">
    <traveler:componentRows hardwareId="${hardwareId}" mode="${mode}" depth="${depth}"/>
</c:if>

<display:table name="${components}" class="datatable">
    <display:column property="lsstId" title="Component" sortable="true" headerClass="sortable"
                    href="displayHardware.jsp" paramId="hardwareId" paramProperty="itemId"/>
    <display:column property="hardwareName" title="Component Type" sortable="true" headerClass="sortable"
                    href="displayHardwareType.jsp" paramId="hardwareTypeId" paramProperty="hardwareTypeId"/>
    <display:column property="begin" sortable="true" headerClass="sortable"/>
    <display:column property="relationshipName" sortable="true" headerClass="sortable"/>
</display:table>
