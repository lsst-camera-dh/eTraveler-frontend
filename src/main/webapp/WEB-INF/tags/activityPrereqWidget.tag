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
<%--
    <sql:query var="componentQ" >
select PP.*, HT.name as hardwareTypeName, H.id as componentId, H.lsstId, PI.creationTS as satisfaction
from PrerequisitePattern PP
inner join Process P on P.id=PP.processId
inner join HardwareType HT on HT.id=PP.hardwareTypeId
inner join Activity A on A.processId=PP.processId
left join (Prerequisite PI 
    inner join Hardware H on H.id=PI.hardwareId)
    on PI.activityId=A.id and PI.prerequisitePatternId=PP.id
where A.id=?<sql:param value="${activityId}"/>
and PP.prerequisiteTypeId=(select id from PrerequisiteType where name='COMPONENT')
order by PP.id
;
    </sql:query>
<c:if test="${! empty componentQ.rows}">
    <h2>Components</h2>
    <display:table name="${componentQ.rows}" id="row" class="datatable">
        <display:column property="name"/>
        <display:column property="description"/>
        <display:column property="hardwareTypeName"/>
        <display:column title="componentId">
            <c:choose>
                <c:when test="${(! empty row.componentId) and (! empty row.satisfaction)}">
                    <c:url value="displayHardware.jsp" var="hwLink">
                        <c:param name="hardwareId" value="${row.componentId}"/>
                    </c:url>
                    <a href="${hwLink}" target="_top"><c:out value="${row.lsstId}"/></a>
                </c:when>
                <c:when test="${(empty row.componentId) and (empty row.satisfaction)}">
                    <form method="get" action="operator/satisfyPrereq.jsp">
                        <input type="hidden" name="freshnessToken" value="${freshnessToken}">
                        <input type="hidden" name="referringPage" value="${thisPage}">
                        <input type="hidden" name="prerequisitePatternId" value="${row.id}">
                        <input type="hidden" name="activityId" value="${activityId}">
                        <input type="hidden" name="hardwareId" value="${activity.hardwareId}">
                        <traveler:componentSelector activityId="${activityId}"/>
                </c:when>
                <c:otherwise>
                    <traveler:error message="Error 202338" bug="true"/>
                </c:otherwise>
            </c:choose>
        </display:column>
        <display:column title="satisfaction">
            <c:choose>
                <c:when test="${(! empty row.componentId) and (! empty row.satisfaction)}">
                    <c:out value="${row.satisfaction}"/>
                </c:when>
                <c:when test="${(empty row.componentId) and (empty row.satisfaction)}">
                    <c:if test="${gotSomeComponents}">
                        <input type="submit" value="Done" <c:if test="${(activity.status != 'new') || (! mayOperate)}">disabled</c:if>>
                    </c:if>
                    </form>
                </c:when>
                <c:otherwise>
                    <traveler:error message="Error 580837" bug="true"/>
                </c:otherwise>
            </c:choose>            
        </display:column>
    </display:table>
</c:if>
--%>
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
