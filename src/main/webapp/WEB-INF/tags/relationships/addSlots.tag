<%-- 
    Document   : addSlots
    Created on : May 17, 2016, 2:36:04 PM
    Author     : focke
--%>

<%@tag description="make sure slots for actions requested by an activity exist" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="relationships" tagdir="/WEB-INF/tags/relationships"%>

<%@attribute name="activityId" required="true"%>

<%-- find requested actions with no corresponding slot --%>
    <sql:query var="slotsQ">
select A.hardwareId, MRST.id as slotTypeId
from Activity A
inner join ProcessRelationshipTag PRT on PRT.processId = A.processId
inner join MultiRelationshipSlotType MRST on MRST.multirelationshipTypeId = PRT.multirelationshipTypeId
left join MultiRelationshipSlot MRS on MRS.multiRelationshipSlotTypeId = MRST.id
    and MRS.hardwareId = A.hardwareId
where A.id = ?<sql:param value="${activityId}"/>
and MRS.id is null
;
    </sql:query>

<%-- make slots --%>
<c:forEach var="slot" items="${slotsQ.rows}">
    <relationships:createSlot var="slotId" slotTypeId="" hardwareId=""/>
</c:forEach>
