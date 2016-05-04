<%-- 
    Document   : showSlots
    Created on : Aug 18, 2015, 12:50:13 PM
    Author     : focke
--%>

<%@tag description="display slots" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="processId"%>
<%@attribute name="activityId"%>

<traveler:fullRequestString var="thisPage"/>

<traveler:checkSlots var="isSane" activityId="${activityId}"/>
<c:if test="${isSane}">

<traveler:getActivitySlots var="slotList" activityId="${activityId}"/>
<c:if test="${! empty slotList}">
    <c:if test="${! empty activityId}">
        <sql:query var="hardwareQ">
select hardwareID from Activity where id=?<sql:param value="${activityId}"/>;
        </sql:query>
        <c:set var="hardwareId" value="${hardwareQ.rows[0].hardwareId}"/>
    </c:if>

    <h3>Component Actions</h3>
    <display:table id="row" name="${slotList}" class="datatable">
        <display:column property="minorTypeName" title="Component Type" sortable="true" headerClass="sortable"
                        href="displayHardwareType.jsp" paramId="hardwareTypeId" paramProperty="minorTypeId"/>
        <display:column property="relName" title="Relationship" sortable="true" headerClass="sortable"/>
        <display:column property="description" title="Description" sortable="true" headerClass="sortable"/>
        <display:column property="slotname" title="Slot" sortable="true" headerClass="sortable"/>
        <display:column property="nMinorItems" title="# Items" sortable="true" headerClass="sortable"/>
        <display:column property="actName" title="Action" sortable="true" headerClass="sortable"/>
        <c:if test="${! empty activityId}">
            <display:column title="Component">
                <c:choose>
                    <c:when test="${! empty row.lsstId}">
                        <c:url var="componentLink" value="displayHardware.jsp">
                            <c:param name="hardwareId" value="${row.minorId}"/>
                        </c:url>
                        <a href="${componentLink}"><c:out value="${row.lsstId}"/></a>
                    </c:when>
                    <c:otherwise>
                        <traveler:checkMask var="mayOperate" activityId="${activityId}"/>
                        <form method="get" action="operator/createRelationship.jsp">
                            <input type="hidden" name="freshnessToken" value="${freshnessToken}">
                            <input type="hidden" name="referringPage" value="${thisPage}">
                            <input type="hidden" name="slotTypeId" value="${row.mrstId}">
                            <input type="hidden" name="activityId" value="${activityId}">
                            <input type="hidden" name="hardwareId" value="${hardwareId}">
                            <traveler:componentSelector var="gotSome" hardwareTypeId="${row.minorTypeId}" quantity="${row.nMinorItems}"/>
                            <input type="submit" value="Assign" <c:if test="${(! gotSome) || (! mayOperate)}">disabled</c:if>>
                        </form>
                    </c:otherwise>
                </c:choose>
            </display:column>
<%--
            <display:column property="processName" title="Step" sortable="true" headerClass="sortable"
                            href="displayActivity.jsp" paramId="activityId" paramProperty="activityId"/>
--%>
            <display:column property="date" sortable="true" headerClass="sortable"/>
        </c:if>
    </display:table>
    
</c:if>
</c:if>
                        