<%-- 
    Document   : childComponentRows
    Created on : Apr 9, 2013, 2:01:16 PM
    Author     : focke
--%>

<%@tag description="Put rows in componentTable" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="relationships" tagdir="/WEB-INF/tags/relationships"%>

<%@attribute name="hardwareId" required="true"%>
<%@attribute name="level" required="true"%>
<%@attribute name="noBatched"%>
<%@attribute name="compList" required="true" type="java.util.List"%>
<%@attribute name="mode" required="true"%>

    <sql:query var="componentsQ">
select 
    ?<sql:param value="${level}"/> as level,
    Hp.lsstId as parent_experimentSN,
    HTp.name as parent_hardwareTypeName,
    Hp.id as parent_id,
    Hc.lsstId as child_experimentSN,
    HTc.name as child_hardwareTypeName,
    Hc.id as child_id,
    MRT.name as relationshipTypeName,
    MRST.slotname as slotName
from Hardware Hp
    inner join HardwareType HTp on HTp.id = Hp.hardwareTypeId
    inner join MultiRelationshipSlot MRS on MRS.hardwareId = Hp.id
    inner join MultiRelationshipSlotType MRST on MRST.id = MRS.multiRelationshipSlotTypeId
    inner join MultiRelationshipType MRT on MRT.id = MRST.multiRelationshipTypeId
    inner join MultiRelationshipHistory MRH on MRH.multiRelationshipSlotId = MRS.id 
        and MRH.id = (select max(id) from MultiRelationshipHistory where multiRelationshipSlotId = MRS.id)
    inner join MultiRelationshipAction MRA on MRA.id = MRH.multiRelationshipActionId
    inner join Hardware Hc on Hc.id = MRH.minorId
    inner join HardwareType HTc on HTc.id = Hc.hardwareTypeId <c:if test="${noBatched}">and HTc.isBatched = 0</c:if>
where 
    H${mode == 'p' ? 'c' : 'p'}.id = ?<sql:param value="${hardwareId}"/>
    and 
    MRA.name = 'install'
    ;
    </sql:query>

<c:set var="nextLevel" value="${level + 1}"/>

<c:forEach var="cRow" items="${componentsQ.rows}">
    <%
        ((java.util.List)jspContext.getAttribute("compList")).add(jspContext.getAttribute("cRow"));
    %>
    <relationships:childComponentRows hardwareId="${mode == 'p' ? cRow.parent_id : cRow.child_id}" 
                                 level="${nextLevel}" 
                                 noBatched="${noBatched}"
                                 compList="${compList}"
                                 mode="${mode}"/>
</c:forEach>
