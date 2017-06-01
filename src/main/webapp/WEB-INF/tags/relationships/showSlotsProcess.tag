<%-- 
    Document   : showSlots
    Created on : May 24, 2016, 1:22:16 PM
    Author     : focke
--%>

<%@tag description="disaplay relationship stuff for a Process" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>

<%@attribute name="processId" required="true"%>

    <sql:query var="actionsQ">
select MRA.name as actName, 
MRT.name as relName, MRT.description, MRT.minorTypeId, if(MRT.singleBatch != 0, MRT.nMinorItems, 1) as nMinorItems, 
HT.name as minorTypeName,
case PRT.slotForm when 'QUERY' then 'Operator Selection NOT SUPPORTED' else MRST.slotName end as slotName
from ProcessRelationshipTag PRT
inner join MultiRelationshipAction MRA on MRA.id = PRT.multiRelationshipActionId
inner join MultiRelationshipType MRT on MRT.id = PRT.multiRelationshipTypeId
inner join HardwareType HT on HT.id = MRT.minorTypeId
left join MultiRelationshipSlotType MRST on case PRT.slotForm
    when 'ALL' then MRST.multiRelationshipTypeId = MRT.id
    when 'SPECIFIED' then MRST.id = PRT.multiRelationshipSlotTypeId
    when 'QUERY' then false
    end
where PRT.processId = ?<sql:param value="${processId}"/>
;
    </sql:query>

<c:if test="${! empty actionsQ.rows}">
    <h2>Install Actions</h2>
    <display:table id="action" name="${actionsQ.rows}" class="datatable">
        <display:column property="relName" title="Relationship" sortable="true" headerClass="sortable"/>
        <display:column property="description" title="Description" sortable="true" headerClass="sortable"/>
        <display:column property="slotname" title="Slot" sortable="true" headerClass="sortable"/>
        <display:column property="minorTypename" title="Type" sortable="true" headerClass="sortable"
                        href="displayHardwareType.jsp" paramId="hardwareTypeId" paramProperty="minorTypeId"/>
        <display:column property="nMinorItems" title="# Items" sortable="true" headerClass="sortable"/>
        <display:column property="actName" title="Action" sortable="true" headerClass="sortable"/>
    </display:table>
</c:if>
