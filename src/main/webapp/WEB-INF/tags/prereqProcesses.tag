<%-- 
    Document   : prereqProcesses
    Created on : Nov 6, 2013, 4:20:34 PM
    Author     : focke
--%>

<%@tag description="Fulfill process prereqs for an Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>

<traveler:fullRequestString var="thisPage"/>
<traveler:checkMask var="mayOperate" activityId="${activityId}"/>

    <sql:query var="prereqsQ" >
select 
Ap.id as activityId, Ap.hardwareId,
PP.id as ppId, PP.name as patternName, PP.prereqProcessId, PP.description,
P.name as processName, P.userVersionString,
AFS.name as status,
Ac.id as childId, Ac.begin
from
Activity Ap
inner join PrerequisitePattern PP on PP.processId=Ap.processId
inner join Process P on P.id=PP.prereqProcessId
inner join ActivityStatusHistory ASH on ASH.activityId=Ap.id and ASH.id=(select max(id) from ActivityStatusHistory where activityId=Ap.id)
inner join ActivityFinalStatus AFS on AFS.id=ASH.activityStatusId
left join (
    Prerequisite PI
    inner join Activity Ac on Ac.id=PI.prerequisiteActivityId
) on PI.prerequisitePatternId=PP.id and PI.activityId=Ap.id
where Ap.id=?<sql:param value="${activityId}"/>
and PP.prerequisiteTypeid=(select id from PrerequisiteType where name='PROCESS_STEP')
order by PP.id
;
    </sql:query>
<c:if test="${! empty prereqsQ.rows}">
    <h2>Required Steps</h2>
    <display:table name="${prereqsQ.rows}" id="row" class="datatable">
        <display:column property="patternName" title="Pattern"/>
        <display:column property="description"/>
        <display:column property="processName" title="Job"/>
        <display:column property="userVersionString" title="Version"/>
        <display:column title="Id, Start">
            <c:choose>
                <c:when test="${! empty row.begin}">
                    ${row.childId}, ${row.begin}
                </c:when>
                <c:otherwise>
                    <sql:query var="activityQ" >
select A.id, A.begin 
from Activity A
inner join ActivityStatusHistory ASH on ASH.activityId=A.id and ASH.id=(select max(id) from ActivityStatusHistory where activityId=A.id)
inner join ActivityFinalStatus AFS on AFS.id=ASH.activityStatusId
where
A.hardwareId=?<sql:param value="${row.hardwareId}"/>
and A.processId=?<sql:param value="${row.prereqProcessId}"/>
and AFS.id=(select id from ActivityFinalStatus where name='success')
order by A.begin desc;
                    </sql:query>
                    <c:choose>
                        <c:when test="${! empty activityQ.rows}">
                            <form method="GET" action="operator/satisfyPrereq.jsp">
                                <input type="hidden" name="freshnessToken" value="${freshnessToken}">
                                <input type="hidden" name="referringPage" value="${thisPage}">
                                <input type="HIDDEN" name="prerequisitePatternId" value="${row.ppId}">
                                <input type="HIDDEN" name="activityId" value="${activityId}">
                                <select name="prerequisiteActivityId">
                                    <c:forEach var="activity" items="${activityQ.rows}">
                                        <option value="${activity.id}">${activity.id}, ${activity.begin}</option>
                                    </c:forEach>
                                </select>
                                <input type="SUBMIT" value="This One" <c:if test="${(row.status != 'new') || (! mayOperate)}">disabled</c:if>>
                            </form>
                        </c:when>
                        <c:otherwise>
                            No suitable job found.
                        </c:otherwise>
                    </c:choose>
                </c:otherwise>
            </c:choose>
        </display:column>
    </display:table>
</c:if>
