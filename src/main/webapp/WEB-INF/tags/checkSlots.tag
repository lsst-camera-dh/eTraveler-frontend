<%-- 
    Document   : checkSlots
    Created on : Apr 27, 2016, 1:20:26 PM
    Author     : focke
--%>

<%@tag description="Sanity check on slots before doing anything" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="isSane" scope="AT_BEGIN"%>

<%-- find any requested actions which have not been done by this activity --%>
<sql:query var="actionsQ">
select A.hardwareId, MRA.id as mraId, MRA.name as actName, MRST.id as mrstId
from Activity A
inner join ProcessRelationshipTag PRT on PRT.processId = A.processId
inner join MultiRelationshipAction MRA on MRA.id = PRT.multiRelationshipActionId
inner join MultiRelationshipSlotType MRST on MRST.multiRelationshipTypeId = PRT.multiRelationshipTypeId
left join MultiRelationshipSlot MRS 
    left join MultiRelationshipHistory MRH on MRH.multiRelationshipSlotId = MRS.id 
    on MRS.multirelationshipSlotTypeId = MRST.id 
        and MRS.hardwareId = A.hardwareId
        and MRH.multiRelationshipActionId = MRA.id
        and MRH.activityId = A.id
where A.id = ?<sql:param value="${activityId}"/>
and MRH.id is null
;
</sql:query>

<c:set var="isSane" value="true"/>
<c:forEach var="action" items="${actionsQ.rows}">
    <%-- all history entries for any slot matching parent component and slot type --%>
    <sql:query var="lastActionQ">
select MRH.id, MRH.creationTS as date, MRA.name as actName,
HT.name as minorTypeName, HT.id as minorTypeId,
MRT.name as relName, MRT.description, MRT.nMinorItems,
MRST.slotname as slotName,
H.id as minorId, H.lsstId,
P.name as processName, MRH.activityId
from MultiRelationshipSlot MRS
inner join MultiRelationshipHistory MRH on MRH.multiRelationshipSlotId = MRS.id
inner join MultiRelationshipAction MRA on MRA.id = MRH.multiRelationshipActionId
inner join Hardware H on H.id = MRS.minorId
inner join HardwareType HT on HT.id = H.hardwareTypeId
inner join MultiRelationshipSlotType MRST on MRST.id = MRS.multiRelationshipSlotTypeId
inner join MultiRelationshipType MRT on MRT.id = MRST.multiRelationshipTypeId
left join Activity A 
    inner join Process P on P.id = A.processId
    on A.id = MRH.activityId
where MRS.hardwareId = ?<sql:param value="${action.hardwareId}"/>
and MRS.multiRelationshipSlotTypeId = ?<sql:param value="${action.mrstId}"/>
order by MRH.id desc
;
    </sql:query>
    <c:set var="lastAction" value="${lastActionQ.rows[0]}"/> <%-- just check the last entry --%>
    <c:set var="message" value=""/>
    <c:choose> 
        <c:when test="${action.actName == 'assign'}">
            <c:choose>
                <c:when test="${lastAction.actName == 'assign'}">
                    <c:set var="message" value="Assign requested, but a component is already assigned."/>
                </c:when>
                <c:when test="${lastAction.actName == 'install'}">
                    <c:set var="message" value="Assign requested, but a component is already installed."/>
                </c:when>
            </c:choose>
        </c:when>
        <c:when test="${(action.actName == 'deassign' and lastAction.actName != 'assign')}">
            <c:set var="message" value="Unassign requested, but last action was not assign."/>
        </c:when>
        <c:when test="${action.actName == 'install'}">
            <c:if test="${lastAction.actName == 'install'}">
                <c:set var="message" value="Install requested, but a component is already installed."/>
            </c:if>
        </c:when>
        <c:when test="${(action.actName == 'uninstall' and lastAction.actName != 'install')}">
            <c:set var="message" value="Uninstall requested, but nothing is installed."/>
        </c:when>
    </c:choose>
    <c:if test="${! empty message}">
        <c:set var="isSane" value="false"/>
        <h1>Relationship error!</h1>
        ${message}<br>
        Full history:<br>
    <display:table id="row" name="${lastActionQ.rows}" class="datatable"> <%-- display all entries if any problem --%>
        <display:column property="minorTypeName" title="Component Type" sortable="true" headerClass="sortable"
                        href="displayHardwareType.jsp" paramId="hardwareTypeId" paramProperty="minorTypeId"/>
        <display:column property="relName" title="Relationship" sortable="true" headerClass="sortable"/>
        <display:column property="description" title="Description" sortable="true" headerClass="sortable"/>
        <display:column property="slotname" title="Slot" sortable="true" headerClass="sortable"/>
        <display:column property="nMinorItems" title="# Items" sortable="true" headerClass="sortable"/>
        <display:column property="actName" title="Action" sortable="true" headerClass="sortable"/>
        <display:column property="lsstId" title="Component" sortable="true" headerClass="sortable"
                        href="displayHardware.jsp" paramId="hardwareId" paramProperty="minorId"/>
        <display:column property="processName" title="Step" sortable="true" headerClass="sortable"
                        href="displayActivity.jsp" paramId="activityId" paramProperty="activityId"/>
        <display:column property="date" sortable="true" headerClass="sortable"/>
    </display:table>
    </c:if>
</c:forEach>