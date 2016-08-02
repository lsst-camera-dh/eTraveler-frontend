<%-- 
    Document   : displaySlotActions
    Created on : May 19, 2016, 3:40:48 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="relationships" tagdir="/WEB-INF/tags/relationships"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="enabled" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="allAssigned" scope="AT_BEGIN"%>

<traveler:fullRequestString var="thisPage"/>

    <sql:query var="actionsQ">
select MRA.name as actName, 
MRT.name as relName, MRT.description, MRT.minorTypeId, if(MRT.singleBatch != 0, MRT.nMinorItems, 1) as nMinorItems, 
HT.name as minorTypeName,
MRST.slotName, MRS.id as slotId, MRH.minorId, MRH.creationTS, H.lsstId
from Activity A
inner join ProcessRelationshipTag PRT on PRT.processId = A.processId
inner join MultiRelationshipAction MRA on MRA.id = PRT.multiRelationshipActionId
inner join MultiRelationshipType MRT on MRT.id = PRT.multiRelationshipTypeId
inner join HardwareType HT on HT.id = MRT.minorTypeId
inner join MultiRelationshipSlotType MRST on MRST.multiRelationshipTypeId = MRT.id
inner join MultiRelationshipSlot MRS on MRS.multiRelationshipSlotTypeId = MRST.id
    and MRS.hardwareId = A.hardwareId
left join MultiRelationshipHistory MRH
    inner join Hardware H on H.id = MRH.minorId
    on MRH.multiRelationshipActionId = MRA.id
        and MRH.multiRelationshipSlotId = MRS.id
        and MRH.activityId = A.id
where A.id = ?<sql:param value="${activityId}"/>
order by MRT.id, MRST.id
;
    </sql:query>

<c:set var="allAssigned" value="true"/>
<display:table id="action" name="${actionsQ.rows}" class="datatable">
    <display:column property="relName" title="Relationship" sortable="true" headerClass="sortable"/>
    <display:column property="description" title="Description" sortable="true" headerClass="sortable"/>
    <display:column property="slotname" title="Slot" sortable="true" headerClass="sortable"/>
    <display:column property="minorTypename" title="Type" sortable="true" headerClass="sortable"
                    href="displayHardwareType.jsp" paramId="hardwareTypeId" paramProperty="minorTypeId"/>
    <display:column property="nMinorItems" title="# Items" sortable="true" headerClass="sortable"/>
    <display:column property="actName" title="Action" sortable="true" headerClass="sortable"/>
    <display:column title="Component">
        <c:choose>
            <c:when test="${! empty action.minorId}">
                <c:url var="minorUrl" value="displayHardware.jsp">
                    <c:param name="hardwareId" value="${action.minorId}"/>
                </c:url>
                <a href='${minorUrl}'>${action.lsstId}</a>
            </c:when>
            <c:otherwise>
                <relationships:getSlotStatus var="status" varId="minorId" slotId="${action.slotId}"/>
                <c:choose>
                    <c:when test="${status == 'free' && (action.actName == 'assign' || action.actName == 'install')}">
                        <%-- TODO: don't display form if action is install and this step has an assign --%>
                        <c:set var="allAssigned" value="false"/>
                        <traveler:checkMask var="mayOperate" activityId="${activityId}"/>
                        <form method="get" action="relationships/assignMinor.jsp">
                            <input type="hidden" name="freshnessToken" value="${freshnessToken}">
                            <input type="hidden" name="referringPage" value="${thisPage}">
                            <input type="hidden" name="slotId" value="${action.slotId}">
                            <input type="hidden" name="activityId" value="${activityId}">
                            <relationships:componentSelector var="gotSome"
                                                             hardwareTypeId="${action.minorTypeId}" 
                                                             quantity="${action.nMinorItems}"/>
                            <input type="submit" value="Assign" <c:if test="${(! gotSome) || (! mayOperate) || (! enabled)}">disabled</c:if>>
                        </form>
                    </c:when>
                     <c:otherwise>
                        <c:url var="minorUrl" value="displayHardware.jsp">
                            <c:param name="hardwareId" value="${minorId}"/>
                        </c:url>
                        <sql:query var="minorQ">
select lsstId from Hardware where id = ?<sql:param value="${minorId}"/>;
                        </sql:query>
                        <a href='${minorUrl}'>${minorQ.rows[0].lsstId}</a>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>
    </display:column>
    <display:column property="creationTS" title="Date" sortable="true" headerClass="sortable"/>
</display:table>
