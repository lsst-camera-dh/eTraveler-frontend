<%-- 
    Document   : closeoutButton
    Created on : Apr 11, 2013, 12:06:18 PM
    Author     : focke
--%>

<%@tag description="Provide buttons to finish an Activity" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="resultsFiled" required="true"%>

<traveler:checkMask var="mayOperate" activityId="${activityId}"/>
<traveler:checkSsPerm var="maySupervise" activityId="${activityId}" roles="supervisor"/>
<c:set var="maySkip" value="${maySupervise}"/>

<traveler:findTraveler var="travelerId" activityId="${activityId}"/>
<c:set var="isTop" value="${travelerId == activityId}"/>
<c:set var="topActivityId" value="${! empty param.topActivityId ? param.topActivityId : travelerId}"/>

    <sql:query var="activityQ" >
select A.*, 
P.substeps, P.maxIteration, P.newLocation, P.newHardwareStatusId,
P.travelerActionMask&(select maskBit from InternalAction where name='harnessedJob') as isHarnessed,
P.travelerActionMask&(select maskBit from InternalAction where name='async') as isAsync,
P.travelerActionMask&(select maskBit from InternalAction where name='setHardwareLocation') as setsLocation,
P.travelerActionMask&(select maskBit from InternalAction where name='setHardwareStatus') as setsStatus,
P.travelerActionMask&(select maskBit from InternalAction where name='addLabel') as addsLabel,
P.travelerActionMask&(select maskBit from InternalAction where name='removeLabel') as removesLabel,
P.travelerActionMask&(select maskBit from InternalAction where name='repeatable') as isRepeatable,
ASH.creationTS as statusTS,
AFS.name as status, AFS.isFinal
from Activity A
inner join Process P on P.id=A.processId
inner join ActivityStatusHistory ASH on ASH.activityId=A.id and ASH.id=(select max(id) from ActivityStatusHistory where activityId=A.id)
inner join ActivityFinalStatus AFS on AFS.id=ASH.activityStatusId
where A.id=?<sql:param value="${activityId}"/>;
    </sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<c:set var="message" value="bug 696274"/>
<c:set var="readyToClose" value="false"/>
<c:choose>
    <c:when test="${activity.status == 'new'}">
        <c:set var="message" value="Not started"/>
    </c:when>
    <c:when test="${! activity.isFinal}">
        <c:set var="message" value="Needs work"/>
        <c:choose>
            <c:when test="${activity.isAsync != 0}">
                <c:set var="message" value="Async job in progress"/>
            </c:when>
            <c:when test="${activity.isHarnessed != 0}">
                <c:set var="message" value="Harnessed job in progress"/>
            </c:when>
            <c:when test="${activity.substeps == 'SEQUENCE'}">
                <sql:query var="stepsRemainingQ" >
select Ac.id
from Activity Ap
inner join ProcessEdge PE on PE.parent=Ap.processId
left join Activity Ac 
    inner join ActivityStatusHistory ASH on ASH.activityId = Ac.id and 
        ASH.id = (select max(id) from ActivityStatusHistory where activityId = Ac.id)
    inner join ActivityFinalStatus AFS on AFS.id = ASH.activityStatusId
    on Ac.processEdgeId=PE.id and Ac.parentActivityId=Ap.id
where Ap.id=?<sql:param value="${activityId}"/>
and not AFS.isFinal    
                </sql:query>
                <c:if test="${empty stepsRemainingQ.rows}">
                    <c:set var="readyToClose" value="true"/>
                </c:if>
            </c:when>
            <c:when test="${activity.substeps == 'SELECTION'}">
                <sql:query var="childQ">
select count(*) as completedSteps
from Activity A 
inner join ActivityStatusHistory ASH on ASH.activityId = A.id and 
    ASH.id = (select max(id) from ActivityStatusHistory where activityId = A.id)
inner join ActivityFinalStatus AFS on AFS.id = ASH.activityStatusId
where A.parentActivityId=?<sql:param value="${activityId}"/>
and AFS.isFinal
                </sql:query>
                <c:if test="${childQ.rows[0].completedSteps != 0}">
                    <c:set var="readyToClose" value="true"/>
                </c:if>
            </c:when>
            <c:when test="${activity.substeps == 'NONE'}">
                <c:set var="readyToClose" value="true"/>                
            </c:when>
        </c:choose>
    </c:when>
    <c:otherwise>
        <c:set var="message" value="${activity.statusTS}"/>
    </c:otherwise>
</c:choose>

<traveler:isStopped var="isStopped" activityId="${activityId}"/>
<c:if test="${isStopped}">
    <%-- This seems an ugly hack. --%>
    <c:set var="readyToClose" value="false"/>
</c:if>

<c:set var="readyToClose" value="${readyToClose && resultsFiled}"/>

<c:set var="active" value="${activity.status == 'new' || activity.status == 'inProgress'}"/>

<c:set var="retryable" value="${(activity.iteration < activity.maxIteration && 
                                    (activity.status == 'new' || 
                                    activity.status == 'inProgress' || 
                                    (isHarnessed && activity.status == 'stopped')
                                    )
                                ) ||
                                activity.isRepeatable == 0}"/>
<c:if test="${readyToClose}">
    <c:set var="message" value="Ready to close"/>
</c:if>
<c:set var="failable" value="${! activity.isFinal && ! travelerFailed}"/> <%-- Argh. travelerFailed is not set in ActivityPane --%>

<traveler:hasOpenSWH var="hasOpenSWH" activityId="${activityId}"/>

<c:set var="repeatable" value="${readyToClose && activity.isRepeatable != 0 && ! isTop}"/>

<c:out value="${message}"/><br>

<form METHOD=GET ACTION="operator/closeoutActivity.jsp" target="_top">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">

    <c:if test="${activity.setsLocation != 0 && readyToClose}">
        <sql:query var="locsQ">
select L.id, L.name 
from Location L 
    inner join Site S on S.id=L.siteId
where S.name=?<sql:param value="${preferences.siteName}"/>
<c:if test="${! empty activity.newLocation}">
    and L.name=?<sql:param value="${activity.newLocation}"/>
</c:if>
;
        </sql:query>
        <c:if test="${empty locsQ.rows}">
            <traveler:error message="This step moves the component to a Location (${activity.newLocation}) that does not exist at your Site.
Your options, easiest to hardest:
Go to the right Site,
Create a new Location,
Make a new version of the Traveler."/>
        </c:if>
        <c:choose>
            <c:when test="${! empty activity.newLocation}">
                <input type="hidden" name="newLocationId" value="${locsQ.rows[0].id}">
            </c:when>
            <c:otherwise>
                Pick a Location:
                <select name="newLocationId">
                    <c:forEach var="loc" items="${locsQ.rows}">
                        <option value="${loc.id}"><c:out value="${loc.name}"/></option>
                    </c:forEach>
                </select>
            </c:otherwise>
        </c:choose>
    </c:if>

    <c:if test="${(activity.setsStatus != 0 || activity.removesLabel != 0 || activity.addsLabel != 0) && empty activity.newHardwareStatusId && readyToClose}">
        <c:choose>
            <c:when test="${activity.setsStatus != 0}">
                <traveler:getAvailableStates var="statesQ" hardwareId="${activity.hardwareId}"/>
                <c:set var="stateInstruction" value="Pick a new status"/>
            </c:when>
            <c:when test="${activity.removesLabel != 0}">
                <traveler:getSetLabels var="statesQ" hardwareId="${activity.hardwareId}"/>
                <c:set var="stateInstruction" value="Pick a label to remove"/>
            </c:when>
            <c:when test="${activity.addsLabel != 0}">
                <traveler:getUnsetLabels var="statesQ" hardwareId="${activity.hardwareId}"/>
                <c:set var="stateInstruction" value="Pick a label to add"/>
            </c:when>
        </c:choose>
        <select name="hardwareStatusId" required>
            <option value="" selected disabled>${stateInstruction}</option>
            <c:forEach var="sRow" items="${statesQ.rows}">
                <option value="${sRow.id}"><c:out value="${sRow.name}"/></option>
            </c:forEach>        
        </select>
    </c:if>

<table>
    <tr>
        <td>
                <input type="hidden" name="activityId" value="${activityId}">       
                <input type="hidden" name="topActivityId" value="${topActivityId}">       
                <INPUT TYPE=SUBMIT value="Complete Step"
                   <c:if test="${(! readyToClose) || (! mayOperate)}">disabled</c:if>>
            </form>      
        </td>
        <td>
        <c:choose>
            <c:when test="${activity.status == 'paused'}">
                <form METHOD=GET ACTION="operator/unPauseTraveler.jsp" target="_top">
                    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
                    <input type="hidden" name="activityId" value="${activityId}">       
                    <INPUT TYPE=SUBMIT value="Resume paused Traveler"
                       <c:if test="${! mayOperate}">disabled</c:if>>
                </form>
            </c:when>
            <c:otherwise>
                <form METHOD=GET ACTION="operator/pauseTraveler.jsp" target="_top">
                    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
                    <input type="hidden" name="activityId" value="${activityId}">       
                    <INPUT TYPE=SUBMIT value="Pause Traveler"
                       <c:if test="${(! active) || (! mayOperate)}">disabled</c:if>>
                </form>
            </c:otherwise>
        </c:choose>
        </td>
        <td>
        <c:choose>
            <c:when test="${repeatable}">
                <form method=GET action="operator/repeatActivity.jsp" target="_top">
                    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
                    <input type="hidden" name="activityId" value="${activityId}">       
                    <input type="hidden" name="topActivityId" value="${topActivityId}">
                    <INPUT TYPE=SUBMIT value="Repeat Step">
                </form>
            </c:when>
            <c:otherwise>
                <form METHOD=GET ACTION="operator/retryActivity.jsp" target="_top">
                    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
                    <input type="hidden" name="activityId" value="${activityId}">       
                    <input type="hidden" name="topActivityId" value="${topActivityId}">
                    <INPUT TYPE=SUBMIT value="Retry Step"
                       <c:if test="${isTop || activity.isRepeatable != 0 ||
                                     (((! retryable) || (! mayOperate)) && ((! active) || (! maySkip)))}">disabled</c:if>>
                </form>
            </c:otherwise>
        </c:choose>
        </td>
        <td>
            <c:choose>
                <c:when test="${hasOpenSWH}">
                    <form METHOD=GET ACTION="supervisor/resolveStop.jsp" target="_top">
                        <input type="hidden" name="freshnessToken" value="${freshnessToken}">
                        <input type="hidden" name="activityId" value="${activityId}">       
                        <INPUT TYPE=SUBMIT value="Resolve Stop Work"
                            <c:if test="${! maySupervise}">disabled</c:if>>
                    </form>                                              
                </c:when>
                <c:otherwise>
                    <form METHOD=GET ACTION="operator/stopWork.jsp" target="_top">
                        <input type="hidden" name="freshnessToken" value="${freshnessToken}">
                        <input type="hidden" name="activityId" value="${activityId}">       
                        <input type="hidden" name="topActivityId" value="${topActivityId}">       
                        <%--<input type="hidden" name="status" value="stopped">--%>
                        <INPUT TYPE=SUBMIT value="Stop Work"
                           <c:if test="${(! failable || ! active) || (! mayOperate)}">disabled</c:if>>
                    </form>                                  
                </c:otherwise>
            </c:choose>
        </td>
        <td>
            <form METHOD=GET ACTION="supervisor/skipStep.jsp" target="_top">
                <input type="hidden" name="freshnessToken" value="${freshnessToken}">
                <input type="hidden" name="activityId" value="${activityId}">
                <input type="hidden" name="topActivityId" value="${topActivityId}">
                <INPUT TYPE=SUBMIT value="Skip Step"
                   <c:if test="${isTop || ((! active) || (! maySkip))}">disabled</c:if>>
            </form>
        </td>
        <td>
            <form method="get" action="supervisor/doNCRInitial.jsp" target="_top">
                <input type="hidden" name="freshnessToken" value="${freshnessToken}">
                <input type="hidden" name="activityId" value="${activityId}">
                <INPUT TYPE=SUBMIT value="NCR"
                   <c:if test="${isTop || ! active}">disabled</c:if>>
            </form>
        </td>
    </tr>
</table>
