<%-- 
    Document   : checkSlots
    Created on : May 17, 2016, 3:59:45 PM
    Author     : focke
--%>

<%@tag description="sanity-check requested rel. actions vs slot status" pageEncoding="UTF-8"%>
<%-- This does not check the database state. It checks that currently requested actions make sense
     in light of the slot state as inferred from the presumed-sane DB. --%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="relationships" tagdir="/WEB-INF/tags/relationships"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="isSane" scope="AT_BEGIN"%>

<%-- find any requested actions which have not been done by this activity --%>
<%-- Assume corresponding slots exist, but may no have history --%>
    <sql:query var="actionsQ">
select MRS.id as slotId, reqMRA.name as reqName, lastMRA.name as lastName
from Activity A
inner join ProcessRelationshipTag PRT on PRT.processId = A.processId
inner join MultiRelationshipAction reqMRA on reqMRA.id = PRT.multiRelationshipActionId
inner join MultiRelationshipSlotType MRST on MRST.multiRelationshipTypeId = PRT.multiRelationshipTypeId
inner join MultiRelationshipSlot MRS on MRS.multiRelationshipSlotTypeId = MRST.id
    and MRS.hardwareId = A.hardwareId
left join MultiRelationshipHistory reqMRH on reqMRH.multiRelationshipSlotId = MRS.id 
    and reqMRH.multiRelationshipActionId = reqMRA.id
    and reqMRH.activityId = A.id
left join MultiRelationshipHistory lastMRH 
    inner join MultiRelationshipAction lastMRA on lastMRA.id = lastMRH.multiRelationshipActionId
    on lastMRH.multiRelationshipSlotId = MRS.id 
        and lastMRH.id = (select max(id) from MultiRelationshipHistory where multiRelationshipSlotId = MRS.id)
where A.id = ?<sql:param value="${activityId}"/>
and reqMRH.id is null
;
    </sql:query>

<c:set var="isSane" value="true"/>
<c:forEach var="action" items="${actionsQ.rows}">
    <c:set var="message" value=""/>
    <c:choose> 
        <c:when test="${action.reqName == 'assign'}">
            <c:choose>
                <c:when test="${action.lastName == 'assign'}">
                    <c:set var="message" value="Assign requested, but a component is already assigned."/>
                </c:when>
                <c:when test="${action.lastName == 'install'}">
                    <c:set var="message" value="Assign requested, but a component is already installed."/>
                </c:when>
            </c:choose>
        </c:when>
        <c:when test="${(action.reqName == 'deassign' and action.lastName != 'assign')}">
            <c:set var="message" value="Unassign requested, but last action was not assign."/>
        </c:when>
        <c:when test="${action.reqName == 'install'}">
            <c:if test="${action.lastName == 'install'}">
                <c:set var="message" value="Install requested, but a component is already installed."/>
            </c:if>
        </c:when>
        <c:when test="${(action.reqName == 'uninstall' and action.lastName != 'install')}">
            <c:set var="message" value="Uninstall requested, but nothing is installed."/>
        </c:when>
    </c:choose>
    <c:if test="${! empty message}">
        <c:set var="isSane" value="false"/>
        <h1>Relationship error!</h1>
        ${message}<br>
        <relationships:showSlotHistory slotId="${action.slotId}"/>
    </c:if>
</c:forEach>
