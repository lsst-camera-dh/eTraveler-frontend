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
<%@taglib prefix="relationships" tagdir="/WEB-INF/tags/relationships"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="newLocationId"%>
<%@attribute name="newLocationReason"%>
<%@attribute name="newStatusId"%>
<%@attribute name="newStatusReason"%>
<%@attribute name="addLabelId"%>
<%@attribute name="addLabelReason"%>
<%@attribute name="removeLabelId"%>
<%@attribute name="removeLabelReason"%>

<ta:setActivityStatus activityId="${activityId}" status="success"/>

    <sql:query var="activityQ">
select A.*, 
P.travelerActionMask&(select maskBit from InternalAction where name='setHardwareLocation') as setsLocation,
P.travelerActionMask&(select maskBit from InternalAction where name='setHardwareStatus') as setsStatus,
P.travelerActionMask&(select maskBit from InternalAction where name='addLabel') as addsLabel,
P.travelerActionMask&(select maskBit from InternalAction where name='removeLabel') as removesLabel,
P.newHardwareStatusId, P.genericLabelId,
MRA.name as relationshipAction
from Activity A
inner join Process P on P.id=A.processId
left join (ProcessRelationshipTag PRT 
    inner join MultiRelationshipAction MRA on MRA.id=PRT.multiRelationshipActionId)
    on PRT.processId=P.id
where A.id=?<sql:param value="${activityId}"/>;
    </sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<sql:query var="objectTypeQ">
    select id from Labelable where name='hardware';
</sql:query>
<c:set var="objectTypeId" value="${objectTypeQ.rows[0].id}" />

<c:if test="${activity.setsLocation != 0}">
    <c:if test="${empty newLocationId}">
            <traveler:error message="No location supplied." bug="true"/>
    </c:if>
    <c:if test="${empty newLocationReason}"><c:set var="newLocationReason" value="Moved by traveler step"/></c:if>
    <ta:setHardwareLocation 
        hardwareId="${activity.hardwareId}" 
        newLocationId="${newLocationId}" 
        activityId="${activityId}"
        reason="${newLocationReason}"/>
</c:if>

<c:if test="${activity.setsStatus!=0}">
    <c:set var="newStatusId" value="${!empty activity.newHardwareStatusId ? activity.newHardwareStatusId : newStatusId}"/>
    <c:if test="${empty newStatusId}">
        <traveler:error message="No hardware status supplied"/>
    </c:if>
    <c:if test="${empty newStatusReason}"><c:set var="newStatusReason" value="Set by traveler step"/></c:if>
    <ta:setHardwareStatus activityId="${activityId}" hardwareId="${activity.hardwareId}"
                          hardwareStatusId="${newStatusId}" reason="${newStatusReason}"/>
</c:if>

<c:if test="${activity.addsLabel!=0}">
    <c:set var="genericLabelId" value="${!empty activity.genericLabelId ? activity.genericLabelId : addLabelId}"/>
    <c:if test="${empty genericLabelId}">
        <traveler:error message="No label supplied"/>
    </c:if>
    <c:if test="${empty addLabelReason}"><c:set var="addLabelReason" value="Applied by traveler step"/></c:if>
    <ta:modifyLabels activityId="${activityId}" objectId="${activity.hardwareId}" objectTypeId="${objectTypeId}"
                     labelId="${genericLabelId}" reason="${addLabelReason}"
                     removeLabel="false"/>
    <
</c:if>

<c:if test="${activity.removesLabel!=0}">
    <c:set var="genericLabelId" value="${!empty activity.genericLabelId ? activity.genericLabelId : removeLabelId}"/>
    <c:if test="${empty genericLabelId}">
        <traveler:error message="No label supplied"/>
    </c:if>
    <c:if test="${empty removeLabelReason}"><c:set var="removeLabelReason" value="Removed by traveler step"/></c:if>
    <ta:modifyLabels activityId="${activityId}" objectId="${activity.hardwareId}" objectTypeId="${objectTypeId}"
                     labelId="${genericLabelId}" reason="${removeLabelReason}"
                     removeLabel="true"/>
</c:if>

<relationships:closeoutRelationship activityId="${activityId}"/>

<c:if test="${initParam['activityAutoCreate']}">
    <%-- This creates the next step if that's what needs to happen. --%>
    <traveler:findTraveler var="travelerId" activityId="${activityId}"/>
    <traveler:expandActivity var="stepList" activityId="${travelerId}"/>
    <traveler:findCurrentStep scriptMode="true" stepList="${stepList}"
                              varStepId="stepId"
                              varStepEPath="stepEPath"
                              varStepLink="stepLink"/>
</c:if>
