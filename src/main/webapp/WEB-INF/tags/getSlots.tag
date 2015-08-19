<%-- 
    Document   : relationshipActions
    Created on : Jul 30, 2015, 11:50:57 AM
    Author     : focke
--%>

<%@tag description="find any relationship actions for a step" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId"%>
<%@attribute name="processId"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="slotList" scope="AT_BEGIN"%>

<c:if test="${! empty activityId}">
    <sql:query var="activityQ">
select * from Activity where id=?<sql:param value="${activityId}"/>;
    </sql:query>
    <c:set var="activity" value="${activityQ.rows[0]}"/>
    <c:set var="processId" value="${activity.processId}"/>
</c:if>
<c:if test="${empty processId}">
    <traveler:error message="bad arguments to getSlots" bug="true"/>
</c:if>

    <sql:query var="slotsQ">
select MRST.id as mrstId,
    PRT.multiRelationshipActionId as intendedActionId, 
    MRA.name
<c:if test="${! empty activityId}">
, MRS.id as mrId, MRH.id as mrhId,    MRH.multiRelationshipActionId as actualActionId
</c:if>
from Process P
    inner join ProcessRelationshipTag PRT on PRT.processId = P.id
    inner join MultiRelationshipType MRT on MRT.id = PRT.multiRelationshipTypeId
    inner join MultiRelationshipAction MRA on MRA.id=PRT.multiRelationshipActionId
    inner join MultiRelationshipSlotType MRST on MRST.multiRelationshipTypeId = MRT.id
<c:if test="${! empty activityId}">
    left join MultiRelationshipSlot MRS on MRS.multiRelationshipSlotTypeId = MRST.id
    left join MultiRelationshipHistory MRH 
                on MRH.multiRelationshipSlotId = MRS.id and MRH.activityId=?<sql:param value="${activityId}"/>
</c:if>
where P.id = ?<sql:param value="${processId}"/>
order by MRST.id desc<c:if test="${! empty activityId}">, MRS.id desc, MRH.id desc</c:if>
;
    </sql:query>
<c:set var="slotList" value="${slotsQ.rows}"/>
