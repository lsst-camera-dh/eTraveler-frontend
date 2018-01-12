<%-- 
    Document   : activitySelectionWidget
    Created on : Jan 15, 2014, 4:21:02 PM
    Author     : focke
--%>

<%@tag description="Handle selection steps" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>

<traveler:checkMask var="mayOperate" activityId="${activityId}"/>

<c:choose>
    <c:when test="${! empty param.topActivityId}">
        <c:set var="topActivityId" value="${param.topActivityId}"/>
    </c:when>
    <c:otherwise>
        <traveler:findTraveler var="topActivityId" activityId="${activityId}"/>
    </c:otherwise>
</c:choose>

    <sql:query var="activityQ">
select 
A.hardwareId, A.begin, A.inNCR,
P.substeps,
AFS.name as status
from Activity A
inner join Process P on P.id = A.processId
inner join ActivityStatusHistory ASH on ASH.activityId=A.id and ASH.id=(select max(id) from ActivityStatusHistory where activityId=A.id)
inner join ActivityFinalStatus AFS on AFS.id=ASH.activityStatusId
where A.id=?<sql:param value="${activityId}"/>;
    </sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

    <sql:query var="choicesQ">
select 
PE.child, PE.id as edgeId, PE.step, 
(case 
        when PE.branchHardwareTypeId is null then 'Default'
        else (select name from HardwareType where id = PE.branchHardwareTypeId)
        end)
as cond,
P.name,
Ac.creationTS
from Activity Ap
inner join ProcessEdge PE on PE.parent=Ap.processId
inner join Process P on P.id=PE.child
left join Activity Ac on Ac.parentActivityId=Ap.id and Ac.processEdgeId=PE.id
where Ap.id=?<sql:param value="${activityId}"/>
order by abs(PE.step);
    </sql:query>
<display:table name="${choicesQ.rows}"/>
<c:set var="numChosen" value="0"/>
<c:forEach items="${choicesQ.rows}" var="childRow">
    <c:if test="${! empty childRow.creationTS}">
        <c:set var="numChosen" value="${numChosen + 1}"/>
    </c:if>
</c:forEach>

<c:set var="conditionTitle" value="${activity.subSteps == 'HARDWARE_SELECTION' ? 'Hardware Type' : 'Condition'}"/>
<c:set var="selectionColumnTitle" value="${numChosen == 0 ? 'Pick One:' : 'Selected:'}"/>

<%-- redirect if hardware selection --%>
<c:set var="doRedirect" value="${activity.substeps == 'HARDWARE_SELECTION' 
                                 && activity.status == 'inProgress'
                                 && numChosen == 0
                                 && mayOperate}"/> <%-- and inProgress ? --%>
[${doRedirect}]<br>

<h2>Selections</h2>
<display:table name="${choicesQ.rows}" id="childRow" class="datatable">
    <display:column property="step" sortable="true" headerClass="sortable"/>
    <display:column property="cond" title="${conditionTitle}" sortable="true" headerClass="sortable"/>
    <display:column title="${selectionColumnTitle}">
        <c:choose>
            <c:when test="${numChosen == 0 && ! empty activity.begin}">
                <form method="get" action="operator/createActivity.jsp" target="_top">
                    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
                    <input type="hidden" name="parentActivityId" value="${activityId}">
                    <input type="hidden" name="hardwareId" value="${activity.hardwareId}">
                    <input type="hidden" name="inNCR" value="${activity.inNCR}">
                    <input type="hidden" name="topActivityId" value="${topActivityId}">
                    <input type="hidden" name="processId" value="${childRow.child}">
                    <input type="hidden" name="processEdgeId" value="${childRow.edgeId}">
                    <input type="submit" value="${childRow.name}"
    <c:if test="${(activity.status != 'new' && activity.status != 'inProgress') || (! mayOperate)}">disabled</c:if>>
                </form>
            </c:when>
            <c:otherwise>
                ${childRow.creationTs}
            </c:otherwise>
        </c:choose>
    </display:column>
</display:table>
