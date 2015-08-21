<%-- 
    Document   : createRelationship
    Created on : Aug 12, 2015, 5:28:16 PM
    Author     : focke
--%>

<%@tag description="create a MultiRelationship" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="hardwareId" required="true"%>
<%@attribute name="minorId" required="true"%>
<%@attribute name="slotTypeId" required="true"%>
<%@attribute name="activityId"%>

    <sql:update>
insert into MultiRelationshipSlot set
hardwareId=?<sql:param value="${hardwareId}"/>,
minorId=?<sql:param value="${minorId}"/>,
multiRelationshipSlotTypeId=?<sql:param value="${slotTypeId}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=utc_timestamp()
;
    </sql:update>
    <sql:query var="slotQ">
select 
    last_insert_id() as slotId
    ,if(MRT.singleBatch != 0, MRT.nMinorItems, 1) as nMinorItems
    ,HT.isBatched
from 
    MultiRelationshipSlotType MRST
    inner join MultiRelationshipType MRT on MRT.id=MRST.multiRelationshipTypeId
    inner join HardwareType HT on HT.id=MRT.minorTypeId
where 
    MRST.id=?<sql:param value="${slotTypeId}"/>
;
    </sql:query>
<c:set var="slot" value="${slotQ.rows[0]}"/>

<ta:updateRelationship slotId="${slot.slotId}" action="assign" activityId="${activityId}"/>

<c:choose>
    <c:when test="${slot.isBatched == 0}">
        <ta:setHardwareStatus hardwareId="${minorId}" hardwareStatusName="USED" activityId="${activityId}"/>
    </c:when>
    <c:otherwise>
        <ta:adjustBatchInventory adjustment="${-1 * slot.nMinorItems}" activityId="${activityId}" hardwareId="${minorId}" reason="assigned by traveler"/>
    </c:otherwise>
</c:choose>
