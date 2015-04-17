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
    P.travelerActionMask&(select maskBit from InternalAction where name='harnessedJob') as isHarnessed,
    P.travelerActionMask&(select maskBit from InternalAction where name='automatable') as isAutomatable,
    P.substeps
    from Activity A
    inner join Process P on P.id=A.processId
    left join ActivityFinalStatus AFS on AFS.id=A.activityFinalStatusId
    where A.id=?<sql:param value="${activityId}"/>;
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<traveler:activityPrereqWidget activityId="${activityId}"/>

<c:if test="${activityQ.rows[0].substeps == 'SELECTION'}"><traveler:selectionWidget activityId="${activityId}"/></c:if>

<traveler:activityInputWidget activityId="${activityId}" var="resultsFiled"/>
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
            <traveler:closeoutButton activityId="${activityId}" resultsFiled="${resultsFiled}"/>
        </td></tr>
        <c:if test="${! empty activity.statusName}">
        <tr><td>Status:</td><td>${activity.statusName}</td></tr>
        </c:if>
</table>

            <traveler:activityStopWidget activityId="${activityId}"/>
<table>
    <tr><td><traveler:ncrLinks activityId="${activityId}" mode="return"/></td></tr>
    <tr><td><traveler:ncrLinks activityId="${activityId}" mode="exit"/></td></tr>
</table>

<c:if test="${! empty activity.begin && activity.isHarnessed != 0}">
    <traveler:jhWidget activityId="${activityId}"/>
</c:if>

<c:if test="${empty activity.end && activity.isAutomatable != 0}">
    <traveler:scriptWidget activityId="${activityId}"/>
</c:if>
