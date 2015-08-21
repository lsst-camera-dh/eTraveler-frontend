<%-- 
    Document   : closeoutRelation
    Created on : Aug 17, 2015, 5:11:26 PM
    Author     : focke
--%>

<%@tag 
    description="This does not (neccessarily) end a MultiRelationship. It does whatever MR action is needed at Activity closeout" 
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>

<%--
    <sql:query var="activityQ">
select A.hardwareId, 
MRA.name as relationshipAction
from Activity A
inner join Process P on P.id=A.processId
left join (ProcessRelationshipTag PRT 
    inner join MultiRelationshipAction MRA on MRA.id=PRT.multiRelationshipActionId
    inner join MultiRelationshipType MRT on MRT.id=PRT.multiRelationshipTypeId
    inner join MultiRelationshipSlotType MRST on MRST.multiRelationshipTypeId=MRT.id
    left join MultiRelationshipSlot MRS on MRS.multiRelationshipSlotTypeId=MRST.id)
    on PRT.processId=P.id
where A.id=?<sql:param value="${activityId}"/>;
    </sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>
--%>

<traveler:getSlots activityId="${activityId}" var="slotList"/>

<c:forEach var="slot" items="${slotList}">
    <c:if test="${(slot.intName == 'install') || (slot.intName == 'uninstall')}">
        <ta:updateRelationship slotId="${slot.mrsId}" action="${slot.intName}" activityId="${activityId}"/>
    </c:if>
</c:forEach>