<%-- 
    Document   : assignMinor
    Created on : Jun 8, 2016, 2:46:14 PM
    Author     : focke
--%>

<%@tag description="assign component to slot" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="batch" tagdir="/WEB-INF/tags/batches"%>
<%@taglib prefix="relationships" tagdir="/WEB-INF/tags/relationships"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="slotId" required="true"%>
<%@attribute name="minorId" required="true"%>
<%@attribute name="activityId"%>

    <sql:query var="minorQ">
select HT.isBatched
from Hardware H
inner join HardwareType HT on HT.id = H.hardwareTypeId
where H.id = ?<sql:param value="${minorId}"/>;
    </sql:query>

<c:if test="${minorQ.rows[0].isBatched != 0}">
    <sql:query var="slotQ">
select MRT.singleBatch, MRT.nMinorItems
from MultiRelationshipSlot MRS
inner join MultiRelationshipSlotType MRST on MRST.id = MRS.multiRelationshipSlotTypeId
inner join MultiRelationshipType MRT on MRT.id = MRST.multiRelationshipTypeId
where MRS.id = ?<sql:param value="${slotId}"/>;
    </sql:query>
    <c:set var="slot" value="${slotQ.rows[0]}"/>

    <c:set var="nItems" value="${slot.singleBatch == 0 ? 1 : slot.nMinorItems}"/>
    
    <sql:query var="childrenQ">
select count(*) as nChildren from BatchedInventoryHistory where sourceBatchId = ?<sql:param value="${minorId}"/>
    </sql:query>
    <c:set var="nChildren" value="${childrenQ.rows[0].nChildren}"/>
    <sql:query var="totalQ">
select sum(adjustment) as batchItems from BatchedInventoryHistory where hardwareId = ?<sql:param value="${minorId}"/>
    </sql:query>
    <c:set var="batchItems" value="${totalQ.rows[0].batchItems}"/>

    <c:if test="${nItems < batchItems}">
        <traveler:error message="Too few items in batch, have ${batchItems}, need ${nItems}"/>
    </c:if>
    
    <c:if test="${nChildren != 0 || batchItems != nItems}">
        <batch:createSubBatch var="minorId" parentId="${minorId}" numItems="${nItems}" activityId="${activityId}"/>
    </c:if>
</c:if>

<relationships:updateRelationship slotId="${slotId}" 
                                  minorId="${minorId}" 
                                  activityId="${activityId}" 
                                  action="assign"/>
