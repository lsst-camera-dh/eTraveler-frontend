<%-- 
    Document   : showSlotHistory
    Created on : May 18, 2016, 2:18:59 PM
    Author     : focke
--%>

<%@tag description="show history for a slot" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>

<%@attribute name="slotId" required="true"%>

    <sql:query var="slotQ">
select MRT.name as relName, MRT.minorTypeId, HT.name as minorTypeName, MRST.slotName
from MultiRelationshipSlot MRS
inner join MultiRelationshipSlotType MRST on MRST.id = MRS.multiRelationshipSlotTypeId
inner join MultiRelationshipType MRT on MRT.id = MRST.multiRelationshipTypeId
inner join HardwareType HT on HT.id = MRT.minorTypeId
where MRS.id = ?<sql:param value="${slotId}"/>
;
    </sql:query>
<c:set var="slot" value="${slotQ.rows[0]}"/>

<c:url var="minorTypeLink" value="displayHardwareType.jsp">
    <c:param name="hardwareTypeId" value="${slot.minorTypeId}"/>
</c:url>
<h3>
<table>
    <tr><td>History for</td><td>relationship</td><td>${slot.relName}</td></tr>
    <tr><td></td><td>slot</td><td>${slot.slotName}</td></tr>
    <tr><td></td><td>child type</td><td><a href="${minorTypeLink}">${slot.minorTypeName}</a></td></tr>
</table>
</h3>

    <sql:query var="historyQ">
select MRA.name as actName, H.id as minorId, H.lsstId, MRH.activityId, P.name as processName, MRH.creationTS,
MRT.name as relName, MRT.description, MRST.slotName, 
if(MRT.singleBatch, MRT.nMinorItems, 1) as nMinorItems
from MultiRelationshipSlot MRS
inner join MultiRelationshipHistory MRH on MRH.multiRelationshipSlotId = MRS.id
inner join Hardware H on H.id = MRH.minorId
inner join MultiRelationshipAction MRA on MRA.id = MRH.multiRelationshipActionId
inner join MultiRelationshipSlotType MRST on MRST.id = MRS.multiRelationshipSlotTypeId
inner join MultiRelationshipType MRT on MRT.id = MRST.multiRelationshipTypeId
left join Activity A
    inner join Process P on P.id = A.processId
    on A.id = MRH.activityId
where MRS.id = ?<sql:param value="${slotId}"/>
order by MRH.id desc
;
    </sql:query>
        
<display:table name="${historyQ.rows}" id="row" class="datatable" sort="list">
    <display:column property="lsstId" title="${appVariables.experiment} Serial Number" sortable="true" headerClass="sortable" 
                    href="displayHardware.jsp" paramId="hardwareId" paramProperty="hardwareId"/>
    <display:column property="relName" title="Relationship" sortable="true" headerClass="sortable"/>
    <display:column property="description" title="Description" sortable="true" headerClass="sortable"/>
    <display:column property="slotname" title="Slot" sortable="true" headerClass="sortable"/>
    <display:column property="nMinorItems" title="# Items" sortable="true" headerClass="sortable"/>
    <display:column property="actName" title="Action" sortable="true" headerClass="sortable"/>
    <display:column property="processName" title="Step" sortable="true" headerClass="sortable"
                    href="displayActivity.jsp" paramId="activityId" paramProperty="activityId"/>
    <display:column property="creationTS" title="Date" sortable="true" headerClass="sortable"/>
</display:table>
