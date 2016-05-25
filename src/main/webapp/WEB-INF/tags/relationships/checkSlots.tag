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
<%-- Assume corresponding slots exist --%>
    <sql:query var="actionsQ">
select MRS.id as slotId, MRA.name
from Activity A
inner join ProcessRelationshipTag PRT on PRT.processId = A.processId
inner join MultiRelationshipAction MRA on MRA.id = PRT.multiRelationshipActionId
inner join MultiRelationshipSlotType MRST on MRST.multiRelationshipTypeId = PRT.multiRelationshipTypeId
inner join MultiRelationshipSlot MRS on MRS.multiRelationshipSlotTypeId = MRST.id
    and MRS.hardwareId = A.hardwareId
left join MultiRelationshipHistory MRH on MRH.multiRelationshipSlotId = MRS.id 
    and MRH.multiRelationshipActionId = MRA.id
    and MRH.activityId = A.id
where A.id = ?<sql:param value="${activityId}"/>
and MRH.id is null
;
    </sql:query>

<c:set var="isSane" value="true"/>
<c:forEach var="action" items="${actionsQ.rows}">
    <relationships:checkAction var="message" action="${action.name}" slotId="${action.slotId}"/>
    <c:if test="${! empty message}">
        <c:set var="isSane" value="false"/>
        <h1>Relationship error!</h1>
        ${message}<br>
        <relationships:showSlotHistory slotId="${action.slotId}"/>
    </c:if>
</c:forEach>
