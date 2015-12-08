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
select MRS.hardwareId, MRS.minorId, MRA.name
from MultiRelationshipSlot MRS
inner join MultiRelationshipHistory MRH on MRH.multirelationshipSlotId=MRS.id
        and MRH.id=(select max(id) from MultiRelationshipHistory where multirelationshipSlotId=MRS.id)
inner join MultiRelationshipAction MRA on MRA.id=MRH.multirelationshipActionId
where MRS.hardwareId=?<sql:param value="${hardwareId}"/>
and MRA.name='install';
    </sql:query>

<c:forEach var="cRow" items="${childrenQ.rows}">
    <traveler:countComponents var="cComps" hardwareId="${cRow.minorId}" top="false"/>
    <c:set var="nComps" value="${nComps + cComps}"/>
</c:forEach>
