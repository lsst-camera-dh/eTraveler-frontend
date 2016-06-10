<%-- 
    Document   : setLocation
    Created on : Sep 30, 2013, 2:53:04 PM
    Author     : focke
--%>

<%@tag description="Change the Location of a component" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="newLocationId" required="true"%>
<%@attribute name="hardwareId" required="true"%>
<%@attribute name="activityId"%>
<%@attribute name="reason" required="true"%>

<sql:update >
    insert into HardwareLocationHistory set
    locationId=?<sql:param value="${newLocationId}"/>,
    hardwareId=?<sql:param value="${hardwareId}"/>,
    <c:if test="${! empty activityId}">
        activityId=?<sql:param value="${activityId}"/>,
    </c:if>
    reason=?<sql:param value="${reason}"/>,
    createdBy=?<sql:param value="${userName}"/>,
    creationTS=UTC_TIMESTAMP();
</sql:update>

    <sql:query var="childrenQ" >
select MRS.hardwareId, MRH.minorId, MRA.name
from MultiRelationshipSlot MRS
inner join MultiRelationshipHistory MRH on MRH.multirelationshipSlotId = MRS.id
        and MRH.id = (select max(id) from MultiRelationshipHistory where multirelationshipSlotId = MRS.id)
inner join MultiRelationshipAction MRA on MRA.id = MRH.multirelationshipActionId
where MRS.hardwareId = ?<sql:param value="${hardwareId}"/>
and MRA.name = 'install';
    </sql:query>
<c:forEach var="childRow" items="${childrenQ.rows}">
    <ta:setHardwareLocation newLocationId="${newLocationId}" 
                            hardwareId="${childRow.minorId}" 
                            activityId="${activityId}" 
                            reason="Moved with parent assembly"/>
</c:forEach>