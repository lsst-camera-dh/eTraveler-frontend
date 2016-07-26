<%-- 
    Document   : getSlots
    Created on : Jul 30, 2015, 11:50:57 AM
    Author     : focke
--%>

<%@tag description="find any slots and history for a step" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="slotList" scope="AT_BEGIN"%>

    <sql:query var="slotsQ">
select MRT.name as relName, MRT.description, MRT.minorTypeId, if(MRT.singleBatch != 0, MRT.nMinorItems, 1) as nMinorItems,
    HT.name as minorTypeName,
    MRST.id as mrstId, MRST.slotName,
    PRT.id as prtId, PRT.multiRelationshipActionId as intendedActionId, 
    MRA.name as actName, 
    MRS.id as mrsId, 
    Hminor.lsstId, Hminor.id as minorId,
    MRH.id as mrhId, MRH.activityId, MRH.creationTS as date
from 
    Activity A
    inner join ProcessRelationshipTag PRT on PRT.processId = A.processId
    inner join MultiRelationshipType MRT on MRT.id = PRT.multiRelationshipTypeId
    inner join HardwareType HT on HT.id = MRT.minorTypeId
    inner join MultiRelationshipAction MRA on MRA.id = PRT.multiRelationshipActionId
    inner join MultiRelationshipSlotType MRST on MRST.multiRelationshipTypeId = MRT.id
    left join MultiRelationshipSlot MRS
        inner join Hardware Hminor on Hminor.id = MRS.minorId
        left join MultiRelationshipHistory MRH on MRH.multiRelationshipSlotId = MRS.id
    on MRS.multiRelationshipSlotTypeId = MRST.id 
        and MRS.hardwareId = A.hardwareId 
        and MRH.multiRelationshipActionId = PRT.multiRelationshipActionId
        and MRH.activityId = A.id
where 
    A.id=?<sql:param value="${activityId}"/>
order by PRT.id, MRST.id, MRH.id
;
    </sql:query>
<c:set var="slotList" value="${slotsQ.rows}"/>
