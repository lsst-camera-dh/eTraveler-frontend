<%-- 
    Document   : getSlots
    Created on : Jul 30, 2015, 11:50:57 AM
    Author     : focke
--%>

<%@tag description="find any slots and history for a step" pageEncoding="UTF-8"%>
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
select MRT.name as relName, MRT.description, MRT.minorTypeId, if(MRT.singleBatch != 0, MRT.nMinorItems, 1) as nMinorItems,
    HTminor.name as minorTypeName,
    MRST.id as mrstId, MRST.slotName,
    PRT.id as prtId, PRT.multiRelationshipActionId as intendedActionId, 
    MRAint.name as intName 
    <c:if test="${! empty activityId}">,
        MRS.id as mrsId, Hminor.lsstId, Hminor.id as minorId,
        MRH.id as mrhId, MRH.activityId, MRH.multiRelationshipActionId as actualActionId, MRH.creationTS as date,
        MRAact.name as actName
    </c:if>
from 
<c:choose>
    <c:when test="${! empty activityId}">
        Activity A
        inner join Process P on P.id=A.processId
        inner join Hardware Hmajor on Hmajor.id=A.hardwareId
    </c:when>
    <c:otherwise>
        Process P
    </c:otherwise>
</c:choose>
    inner join ProcessRelationshipTag PRT on PRT.processId = P.id
    inner join MultiRelationshipType MRT on MRT.id = PRT.multiRelationshipTypeId
    <c:if test="${! empty activityId}">
        and MRT.hardwareTypeId = Hmajor.hardwareTypeId
    </c:if>
    inner join HardwareType HTminor on HTminor.id=MRT.minorTypeId
    inner join MultiRelationshipAction MRAint on MRAint.id=PRT.multiRelationshipActionId
    inner join MultiRelationshipSlotType MRST on MRST.multiRelationshipTypeId = MRT.id
<c:if test="${! empty activityId}">
    left join (MultiRelationshipSlot MRS
        inner join Hardware Hminor on Hminor.id=MRS.minorId) on MRS.multiRelationshipSlotTypeId=MRST.id and MRS.hardwareId=A.hardwareId
    left join (MultiRelationshipHistory MRH
        inner join MultiRelationshipAction MRAact on MRAact.id=MRH.multiRelationshipActionId) 
        on MRH.multiRelationshipSlotId = MRS.id and MRH.multiRelationshipActionId=PRT.multiRelationshipActionId
</c:if>
where 
<c:choose>
    <c:when test="${! empty activityId}">
        A.id=?<sql:param value="${activityId}"/>
    </c:when>
    <c:otherwise>
        P.id = ?<sql:param value="${processId}"/>
    </c:otherwise>
</c:choose>
order by PRT.id, MRST.id
;
    </sql:query>
<c:set var="slotList" value="${slotsQ.rows}"/>

<c:if test="${! empty activityId}">
<c:forEach var="row" items="${slotList}">
    <c:if test="${row.actName == 'install' && row.activityId != activityId}">
        <traveler:error message="Step calls for component ${row.minorTypeName} install in slot ${row.relName} ${row.slotName}, but the slot is already full."/>
    </c:if>
</c:forEach>
</c:if>
