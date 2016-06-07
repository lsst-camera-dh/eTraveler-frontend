<%-- 
    Document   : updateHardwareRelationship
    Created on : Jul 28, 2015, 5:31:05 PM
    Author     : focke
--%>

<%@tag description="Add to the history of a HardwareRelationship" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="slotId" required="true"%>
<%@attribute name="action" required="true"%>
<%@attribute name="minorId" required="true"%>
<%@attribute name="activityId"%>
<%@attribute name="reason"%>

    <sql:update>
insert into MultiRelationshipHistory set
multiRelationshipSlotId=?<sql:param value="${slotId}"/>,
minorId=?<sql:param value="${minorId}"/>,
multiRelationshipActionId=(select id from MultiRelationshipAction where name=?<sql:param value="${action}"/>),
activityId=?<sql:param value="${activityId}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=utc_timestamp()
;
    </sql:update>

<c:if test="${empty reason && ! empty activityId}">
    <c:url var="activityUrl" value="displayActivity.jsp">
        <c:param name="activityId" value="${activityId}"/>
    </c:url>
    <sql:query var="activityQ">
select P.name
from Activity A
inner join Process P on P.id = A.processId
where A.id = ?<sql:param value="${activityId}"/>
;
    </sql:query>
    <c:set var="activityLink" value="<a href='${activityUrl}'>${activityQ.rows[0].name}</a>"/>
    <c:set var="reason" value="${action}ed by Activity ${activityLink}"/>
</c:if>

    <sql:query var="htQ">
select HT.isBatched
from Hardware H
inner join HardwareType HT on HT.id = H.hardwareTypeId
where H.id = ?<sql:param value="${minorId}"/>
    </sql:query>

<c:choose>
    <c:when test="${htQ.rows[0].isBatched != 0}">
        <sql:query var="slotQ">
select if(MRT.singleBatch != 0, MRT.nMinorItems, 1) as nMinorItems
from MultiRelationshipSlot MRS
inner join MultiRelationshipSlotType MRST on MRST.id = MRS.multiRelationshipSlotTypeId
inner join MultiRelationshipType MRT on MRT.id = MRST.multiRelationshipTypeId
where MRS.id = ?<sql:param value="${slotId}"/>
        </sql:query>
        <c:set var="slot" value="${slotQ.rows[0]}"/>
        <c:choose>
            <c:when test="${action == 'assign'}">
                <c:set var="batch" value="${minorId}"/>
                <c:set var="adjustment" value="${-1 * slot.nMinorItems}"/>
            </c:when>
            <c:when test="${action == 'deassign' || action == 'uninstall'}">
                <ta:getPendingBatch var="batch" hardwareId="${minorId}" activityId="${activityId}"/>
                <c:set var="adjustment" value="${slot.nMinorItems}"/>
            </c:when>
        </c:choose>
        <c:if test="${! empty batch}">
            <ta:adjustBatchInventory hardwareId="${batch}" 
                                     adjustment="${adjustment}" 
                                     activityId="${activityId}" 
                                     reason="${reason}"/>
        </c:if>
    </c:when>
    <c:otherwise>
        <c:choose>
            <c:when test="${action == 'assign'}">
                <c:set var="newStatus" value="USED"/>
            </c:when>
            <c:when test="${action == 'deassign' || action == 'uninstall'}">
                <c:set var="newStatus" value="PENDING"/>
            </c:when>
        </c:choose>
        <c:if test="${! empty newStatus}">
            <ta:setHardwareStatus hardwareId="${minorId}" 
                                  hardwareStatusName="${newStatus}" 
                                  activityId="${activityId}" 
                                  reason="${reason}"/>
        </c:if>
    </c:otherwise>
</c:choose>
