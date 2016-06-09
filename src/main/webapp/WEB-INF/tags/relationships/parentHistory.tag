<%-- 
    Document   : parentHistory
    Created on : May 27, 2016, 3:50:04 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>

<%@attribute name="hardwareId" required="true"%>

    <sql:query var="parentsQ">
select H.lsstId, MRS.hardwareId,
    MRA.name as actName,
    MRH.activityId, A.processId, P.name as processName,
    MRT.name as relName, MRT.description, MRST.slotName, MRT.nMinorItems,
    MRH.creationTS
from MultiRelationshipHistory MRH
inner join MultiRelationshipAction MRA on MRA.id = MRH.multiRelationshipActionId
inner join MultiRelationshipSlot MRS on MRS.id = MRH.multiRelationshipSlotId
inner join MultiRelationshipSlotType MRST on MRST.id = MRS.multiRelationshipSlotTypeId
inner join MultiRelationshipType MRT on MRT.id = MRST.multiRelationshipTypeId
inner join Hardware H on H.id = MRS.hardwareId
inner join HardwareType HT on HT.id = H.hardwareTypeId
left join Activity A
    inner join Process P on P.id = A.processId
    on A.id = MRH.activityId
where MRH.minorId = ?<sql:param value="${hardwareId}"/>
order by MRH.id desc
;
    </sql:query>

<display:table name="${parentsQ.rows}" id="row" class="datatable" sort="list">
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
