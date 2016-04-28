<%-- 
    Document   : checkSlots
    Created on : Apr 27, 2016, 1:20:26 PM
    Author     : focke
--%>

<%@tag description="Sanity check on slots before doing anything" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="isSane" scope="AT_BEGIN"%>

<%-- find any requested actions which have not been done by this activity --%>
<sql:query var="actionsQ">
select A.hardwareId, MRA.id as mraId, MRA.name, MRST.id as mrstId
from Activity A
inner join ProcessRelationshipTag PRT on PRT.processId = A.processId
inner join MultiRelationshipAction MRA on MRA.id = PRT.multiRelationshipActionId
inner join MultiRelationshipSlotType MRST on MRST.multiRelationshipTypeId = PRT.multiRelationshipTypeId
left join MultiRelationshipSlot MRS on MRS.multrelationshipSlotTypeId = MRST.id 
    and MRS.hardwareId = A.hardwareId
left join MultiRelationshipHistory MRH on MRH.multiRelationshipSlotId = MRS.id 
    and MRH.multiRelationshipActionId = MRA.id
    and MRH.activityId = A.id
where A.id = ?<sql:param value="${activityId}"/>
and MRH.id is null
;
</sql:query>

<c:set var="isSane" value="true"/>
<c:forEach var="action" items="${actionsQ.rows}">
    <%-- last history entry for any slot matching parent component and slot type
    that was not done by this Activity --%>
    <sql:query var="lastActionQ">
select MRH.id, MRA.name
from MultiRelationshipSlot MRS
inner join MultiRelationshipHistory MRH on MRH.multiRelationshipSlotId = MRS.id
inner join MultiRelationshipAction MRA on MRA.id = MRH.multiRelationshipActionId
where MRS.hardwareId = ?<sql:param value="${action.hardwareId}"/>
and MRS.multiRelationshipSlotType = ?<sql:param value="${action.mrstId}"/>
order by MRH.id desc limit 1
;
    </sql:query>
    <c:set var="lastAction" value="${lastActionQ.rows[0]}"/>
    <c:if test="${(action.name == 'assign' and (lastAction.name == 'assign' or lastAction.name == 'install')) 
                  or (action.name == 'install' and !empty lastAction and lastAction.name != 'assign') 
                  or (action.name == 'uninstall' and lastAction.name != 'install')}">
        <c:set var="isSane" value="false"/>
    </c:if>
</c:forEach>