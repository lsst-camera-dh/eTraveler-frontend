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

<c:if test="${! empty activityId}">
    <sql:query var="activityQ">
select * from Activity where id=?<sql:param value="${activityId}"/>;
    </sql:query>
    <c:set var="activity" value="${activityQ.rows[0]}"/>
    <c:set var="processId" value="${activity.processId}"/>
</c:if>
<c:if test="${empty processId}">
    <traveler:error message="bad arguments to relationshipActions" bug="true"/>
</c:if>

    <sql:query var="actionsQ">
select MRST.id as mrstId, MR.id as mrId, MRH.id as mrhId,
    PRT.multiRelationshipActionId as intendedActionId,
    MRH.multiRelationshipActionId as actualActionId
from Process P
    inner join ProcessRelationshipTag PRT on PRT.processId = P.id
    inner join MultiRelationshipType MRT on MRT.id = PRT.multiRelationshipTypeId
    inner join MultiRelationshipAction MRA on MRA.id=PRT.multiRelationshipActionId
    inner join MultiRelationshipSlotType MRST on MRST.multiRelationshipTypeId = MRT.id
<c:if test="${! empty activityId}">
    left join MultiRelationship MR on MR.multiRelationshipSlotTypeId = MRST.id
    left join MultiRelationshipHistory MRH 
                on MRH.multiRelationshipId = MR.id and MRH.activityId=?<sql:param value="${activityId}"/>
</c:if>
where P.id = ?<sql:param value="${processId}"/>
order by MRST.id desc, MR.id desc, MRH.id desc
;
    </sql:query>