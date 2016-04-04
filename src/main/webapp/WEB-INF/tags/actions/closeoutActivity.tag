<%-- 
    Document   : closeoutActivity
    Created on : Apr 15, 2015, 11:12:22 AM
    Author     : focke
--%>

<%@tag description="Close out (successfully) an Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="newLocationId"%>
<%@attribute name="newStatusId"%>

<ta:setActivityStatus activityId="${activityId}" status="success"/>

    <sql:query var="activityQ">
select A.*, 
P.travelerActionMask&(select maskBit from InternalAction where name='setHardwareLocation') as setsLocation,
P.travelerActionMask&(select maskBit from InternalAction where name='setHardwareStatus') as setsStatus,
P.travelerActionMask&(select maskBit from InternalAction where name='addLabel') as addsLabel,
P.travelerActionMask&(select maskBit from InternalAction where name='removeLabel') as removesLabel,
P.newHardwareStatusId,
MRA.name as relationshipAction
from Activity A
inner join Process P on P.id=A.processId
left join (ProcessRelationshipTag PRT 
    inner join MultiRelationshipAction MRA on MRA.id=PRT.multiRelationshipActionId)
    on PRT.processId=P.id
where A.id=?<sql:param value="${activityId}"/>;
    </sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<c:if test="${activity.setsLocation != 0}">
    <c:if test="${empty newLocationId}">
            <traveler:error message="No location supplied." bug="true"/>
    </c:if>
    <ta:setHardwareLocation 
        hardwareId="${activity.hardwareId}" 
        newLocationId="${newLocationId}" 
        activityId="${activityId}"
        reason="Moved by traveler"/>
</c:if>

<c:if test="${activity.setsStatus!=0 || activity.addsLabel!=0 || activity.removesLabel!=0}">
    <c:set var="newStatusId" value="${!empty activity.newHardwareStatusId ? activity.newHardwareStatusId : newStatusId}"/>
    <c:if test="${empty newStatusId}">
        <traveler:error message="No hardware status supplied"/>
    </c:if>
    <c:set var="removeLabel" value="${activity.removesLabel!=0 ? true : false}"/>
    <ta:setHardwareStatus activityId="${activityId}" hardwareId="${activity.hardwareId}"
                          hardwareStatusId="${newStatusId}" reason="Set by traveler step"
                          removeLabel="${removeLabel}"/>
</c:if>

<ta:closeoutRelationship activityId="${activityId}"/>

<c:if test="${initParam['activityAutoCreate']}">
    <%-- This creates the next step if that's what needs to happen. --%>
    <traveler:findTraveler var="travelerId" activityId="${activityId}"/>
    <traveler:expandActivity var="stepList" activityId="${travelerId}"/>
    <traveler:findCurrentStep scriptMode="true" stepList="${stepList}"
                              varStepId="stepId"
                              varStepEPath="stepEPath"
                              varStepLink="stepLink"/>
</c:if>
