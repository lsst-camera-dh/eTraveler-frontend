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
<%@attribute name="compList" required="true" type="java.util.List"%>

<c:choose>
    <c:when test="${mode=='c'}">
        <c:set var="me" value="hardwareId"/>
        <c:set var="you" value="minorId"/>
    </c:when>
    <c:when test="${mode=='p'}">
        <c:set var="me" value="minorId"/>
        <c:set var="you" value="hardwareId"/>
    </c:when>
    <c:otherwise>
        <c:set var="me" value="tarzan"/>
        <c:set var="you" value="jane"/>
        <traveler:error message="Bad mode in component tree." bug="true"/>
    </c:otherwise>
</c:choose>

<c:set var="newDepth" value="${depth - 1}"/>

    <sql:query var="componentsQ">
select 
    MRS.${you} as itemId, 
    MRH.creationTS as date,
    MRA.name as action,
    MRT.name as relationshipName, 
    MRST.slotname,
    HT.name as hardwareName, HT.id as hardwareTypeId, 
    H.lsstId
from MultiRelationshipSlot MRS
    inner join MultiRelationshipSlotType MRST on MRST.id=MRS.multiRelationshipSlotTypeId
    inner join MultiRelationshipType MRT on MRT.id=MRST.multiRelationshipTypeId
    inner join MultiRelationshipHistory MRH on MRH.multiRelationshipSlotId=MRS.id 
        and MRH.id=(select max(id) from MultiRelationshipHistory where multiRelationshipSlotId=MRS.id)
    inner join MultiRelationshipAction MRA on MRA.id=MRH.multiRelationshipActionId
    inner join Hardware H on H.id=MRS.${you}
    inner join HardwareType HT on HT.id=H.hardwareTypeId
where 
    MRS.${me}=?<sql:param value="${hardwareId}"/>
    and 
    MRA.name!='uninstall'
    ;
    </sql:query>

<c:forEach var="cRow" items="${componentsQ.rows}">
    <%
        ((java.util.List)jspContext.getAttribute("compList")).add(jspContext.getAttribute("cRow"));
    %>
    <c:if test="${newDepth > 0}">
        <traveler:componentRows hardwareId="${cRow.itemId}" mode="${mode}" depth="${newDepth}" compList="${compList}"/>
    </c:if>
</c:forEach>