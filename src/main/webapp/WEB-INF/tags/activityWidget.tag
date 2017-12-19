<%-- 
    Document   : activityWidget
    Created on : May 17, 2013, 1:16:30 PM
    Author     : focke
--%>

<%@tag description="Display various stuff about an Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId"%>

<sql:query var="activityQ" >
    select A.*, AFS.name as statusName,
    P.description, P.instructionsUrl,
    P.travelerActionMask&(select maskBit from InternalAction where name='harnessedJob') as isHarnessed,
    P.travelerActionMask&(select maskBit from InternalAction where name='automatable') as isAutomatable,
    P.substeps,
    JSH.id as jshId
    from Activity A
    inner join Process P on P.id=A.processId
    inner join ActivityStatusHistory ASH on ASH.activityId=A.id and ASH.id=(select max(id) from ActivityStatusHistory where activityId=A.id)
    inner join ActivityFinalStatus AFS on AFS.id=ASH.activityStatusId
    left join JobStepHistory JSH on JSH.activityId=A.id and JSH.id=(select max(id) from JobStepHistory where activityId=A.id)
    where A.id=?<sql:param value="${activityId}"/>;
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<traveler:activityPrereqWidget activityId="${activityId}"/>

<c:if test="${! empty activity.description}">
    <c:out value="${activity.description}" escapeXml="false"/>
    <br>
</c:if>

<c:if test="${! empty activity.instructionsURL}">
    <a href="${activity.instructionsURL}">Detailed Instructions</a>
</c:if>

<c:if test="${! empty activity.begin && activity.isHarnessed != 0 && empty activity.end && empty activity.jshId}">
    <traveler:jhCommand var="command" varError="allOk" activityId="${activityId}"/>
    Now enter the following command:<br>
    &nbsp;&nbsp;<c:out value="${command}"/><br>
    <traveler:cors command="${command}"/>
</c:if>

<c:if test="${empty activity.end && activity.isAutomatable != 0}">
    <traveler:scriptWidget activityId="${activityId}"/>
</c:if>

<c:if test="${activityQ.rows[0].substeps == 'SELECTION' || processQ.rows[0].substeps == 'HARDWARE_SELECTION'}"><traveler:activitySelectionWidget activityId="${activityId}"/></c:if>

<traveler:activityInputWidget activityId="${activityId}" var="resultsFiled"/>
<traveler:activitySignatureWidget var="signedOff" activityId="${activityId}" resultsFiled="${resultsFiled}"/>
<traveler:activityActionWidget activityId="${activityId}"/>

<table>
    <tr>
        <td>Started:</td>
        <td>
            <c:choose>
                <c:when test="${empty activity.begin}">
                    In Prep
                </c:when>
                <c:otherwise>
                    <c:out value="${activity.begin}"/> by <c:out value="${activity.createdBy}"/>
                </c:otherwise>
            </c:choose>
        </td>
    </tr>
    <tr><td>End:</td>
        <td>
            <traveler:closeoutButton activityId="${activityId}" resultsFiled="${resultsFiled and signedOff}"/>
        </td></tr>
        <c:if test="${! empty activity.statusName}">
        <tr><td>Status:</td><td>${activity.statusName}</td></tr>
        </c:if>
</table>

<c:if test="${activity.isHarnessed != 0}">
    <traveler:jhWidget activityId="${activityId}"/>
</c:if>

<traveler:activityStatusWidget activityId="${activityId}"/>

<traveler:activityStopWidget activityId="${activityId}"/>

<table>
    <tr><td><traveler:ncrLinks activityId="${activityId}" mode="return"/></td></tr>
    <tr><td><traveler:ncrLinks activityId="${activityId}" mode="exit"/></td></tr>
</table>
