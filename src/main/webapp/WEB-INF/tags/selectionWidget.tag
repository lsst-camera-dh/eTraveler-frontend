<%-- 
    Document   : selectionWidget
    Created on : Jan 15, 2014, 4:21:02 PM
    Author     : focke
--%>

<%@tag description="Handle selection steps" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" %>
<%@attribute name="processId" %>

<traveler:checkPerm var="mayOperate" groups="EtravelerOperator,EtravelerSupervisor"/>

<c:choose>
    <c:when test="${! empty param.topActivityId}">
        <c:set var="topActivityId" value="${param.topActivityId}"/>
    </c:when>
    <c:otherwise>
        <traveler:findTraveler var="topActivityId" activityId="${activityId}"/>
    </c:otherwise>
</c:choose>

<sql:query var="choicesQ">
     <c:choose>
       <c:when test="${! empty activityId}">
select 
Ap.hardwareId, Ap.begin, Ap.inNCR,
PE.child, PE.id as edgeId, PE.step, PE.cond,
P.name,
AFS.name as status,
Ac.creationTS
from Activity Ap
inner join ProcessEdge PE on PE.parent=Ap.processId
inner join Process P on P.id=PE.child
inner join ActivityStatusHistory ASH on ASH.activityId=Ap.id and ASH.id=(select max(id) from ActivityStatusHistory where activityId=Ap.id)
inner join ActivityFinalStatus AFS on AFS.id=ASH.activityStatusId
left join Activity Ac on Ac.parentActivityId=Ap.id and Ac.processEdgeId=PE.id
where Ap.id=?<sql:param value="${activityId}"/>
order by abs(PE.step);
    </c:when>
    <c:otherwise>
select 
PE.child, PE.id as edgeId, PE.step, PE.cond,
P.name
from ProcessEdge PE
inner join Process P on P.id=PE.child
where PE.parent=?<sql:param value="${processId}"/>
order by abs(PE.step);
    </c:otherwise>
</c:choose>
</sql:query>

<c:set var="numChosen" value="0"/>
<c:forEach items="${choicesQ.rows}" var="childRow">
    <c:if test="${! empty childRow.creationTS}">
        <c:set var="numChosen" value="${numChosen + 1}"/>
    </c:if>
</c:forEach>

<c:choose>
    <c:when test="${numChosen == 0}">
        <c:set var="selectionColumnTitle" value="Pick One:"/>
    </c:when>
    <c:otherwise>
        <c:set var="selectionColumnTitle" value="Selected:"/>        
    </c:otherwise>
</c:choose>

<h2>Selections</h2>
<display:table name="${choicesQ.rows}" id="childRow" class="datatable">
    <display:column property="step" sortable="true" headerClass="sortable"/>
    <display:column property="cond" title="Condition" sortable="true" headerClass="sortable"/>
    <c:if test="${! empty activityId}">
        <display:column title="${selectionColumnTitle}">
            <c:choose>
                <c:when test="${numChosen == 0 && ! empty childRow.begin}">
                    <form method="get" action="operator/createActivity.jsp" target="_top">
                        <input type="hidden" name="parentActivityId" value="${activityId}">
                        <input type="hidden" name="hardwareId" value="${childRow.hardwareId}">
                        <input type="hidden" name="inNCR" value="${childRow.inNCR}">
                        <input type="hidden" name="topActivityId" value="${topActivityId}">
                        <input type="hidden" name="processId" value="${childRow.child}">
                        <input type="hidden" name="processEdgeId" value="${childRow.edgeId}">
                        <input type="submit" value="${childRow.name}"
                               <c:if test="${(childRow.status != 'new' && childRow.status != 'inProgress') || (! mayOperate)}">disabled</c:if>>
                    </form>
                </c:when>
                <c:otherwise>
                    ${childRow.creationTs}
                </c:otherwise>
            </c:choose>
        </display:column>
    </c:if>
</display:table>
