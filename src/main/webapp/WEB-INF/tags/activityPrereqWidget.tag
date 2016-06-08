<%-- 
    Document   : activityPrereqWidget
    Created on : Jul 15, 2013, 2:32:28 PM
    Author     : focke
--%>

<%@tag description="Display various stuff about prereqs for an Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="relationships" tagdir="/WEB-INF/tags/relationships"%>

<%@attribute name="activityId" required="true"%>

<traveler:fullRequestString var="thisPage"/>
<traveler:checkMask var="mayOperate" activityId="${activityId}"/>

<c:choose>
    <c:when test="${! empty param.topActivityId}">
        <c:set var="topActivityId" value="${param.topActivityId}"/>
    </c:when>
    <c:otherwise>
        <traveler:findTraveler var="topActivityId" activityId="${activityId}"/>
    </c:otherwise>
</c:choose>

    <sql:query var="activityQ" >
select A.*,
    AFS.name as status, AFS.isFinal
from Activity A
    inner join ActivityStatusHistory ASH on ASH.activityId=A.id and ASH.id=(select max(id) from ActivityStatusHistory where activityId=A.id)
    inner join ActivityFinalStatus AFS on AFS.id=ASH.activityStatusId
where A.id=?<sql:param value="${activityId}"/>
;
    </sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<traveler:prereqProcesses activityId="${activityId}"/>
<traveler:prereqTable prereqTypeName="TEST_EQUIPMENT" activityId="${activityId}"/>
<traveler:prereqTable prereqTypeName="CONSUMABLE" activityId="${activityId}"/>
<traveler:prereqTable prereqTypeName="PREPARATION" activityId="${activityId}"/>

<c:choose>
    <c:when test="${activity.status == 'new'}">
        <sql:query var="prereqQ" >
            select count(PP.id)-count(PR.id) as prsRemaining from
            PrerequisitePattern PP
            inner join Activity A on A.processId=PP.processId
            left join Prerequisite PR on PR.activityId=A.id and PR.prerequisitePatternId=PP.id
            where A.id=?<sql:param value="${activityId}"/>
                and PP.prerequisiteTypeId != (select id from PrerequisiteType where name = 'COMPONENT')
        </sql:query>
        <c:set var="readyToStart" value="${prereqQ.rows[0].prsRemaining==0}"/>
    </c:when>
    <c:otherwise>
        <c:set var="readyToStart" value="false"/>
    </c:otherwise>
</c:choose>

<relationships:showSlotsActivity var="slotsOk" activityId="${activityId}"/>

<form method="get" action="operator/startActivity.jsp" target="_top">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
    <input type="hidden" name="activityId" value="${activityId}">
    <input type="hidden" name="topActivityId" value="${topActivityId}">
    <input type="submit" value="Start Step"
           <c:if test="${(! readyToStart) || (! mayOperate) || (! slotsOk)}">disabled</c:if>>
</form>                    
