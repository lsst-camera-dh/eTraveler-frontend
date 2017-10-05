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
P.substeps, P.maxIteration, P.siteId, P.newLocation, P.newHardwareStatusId, P.genericLabelId, P.labelGroupId,
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
                                ) &&
                                activity.isRepeatable == 0}"/>

<c:set var="repeatable" value="${readyToClose && activity.isRepeatable != 0 && ! isTop}"/>

<c:choose>
    <c:when test="${repeatable}">
        <c:set var="message" value="<h3>Ready to repeat or close</h3>"/>
    </c:when>
    <c:when test="${readyToClose}">
        <c:set var="message" value="Ready to close"/>
    </c:when>
</c:choose>

<c:set var="failable" value="${! activity.isFinal && ! travelerFailed}"/> <%-- Argh. travelerFailed is not set in ActivityPane --%>

<traveler:hasOpenSWH var="hasOpenSWH" activityId="${activityId}"/>

<c:out value="${message}"/><br>

<form METHOD=GET ACTION="operator/closeoutActivity.jsp" target="_top">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">

    <c:if test="${readyToClose}">
<table><tr>
    <c:if test="${activity.setsLocation != 0}">
        <c:choose>
            <c:when test="${! empty activity.siteId}">
                <c:set var="siteId" value="${activity.siteId}"/>
            </c:when>
            <c:otherwise>
                <sql:query var="siteQ">
                    select id from Site where name = ?<sql:param value="${preferences.siteName}"/>;
                </sql:query>
                <c:set var="siteId" value="${siteQ.rows[0].id}"/>
            </c:otherwise>
        </c:choose>
        <sql:query var="siteQ">
            select name from Site where id = ?<sql:param value="${siteId}"/>;
        </sql:query>
        <c:set var="siteName" value="${siteQ.rows[0].name}"/>
                    
        <sql:query var="locsQ">
select L.id, L.name, S.name as siteName
from Location L 
    inner join Site S on S.id=L.siteId
where S.id=?<sql:param value="${siteId}"/>
<c:if test="${! empty activity.newLocation}">
    and L.name=?<sql:param value="${activity.newLocation}"/>
</c:if>
;
        </sql:query>
        <c:if test="${empty locsQ.rows}">
            <traveler:error message="This step moves the component to a Location (${activity.newLocation}) that does not exist at your Site (${siteName}).
Your options, easiest to hardest:
Go to the right Site,
Create a new Location,
Make a new version of the Traveler."/>
        </c:if>
        <c:set var="newLocationReason" value="Moved by traveler step"/>
        <c:choose>
            <c:when test="${! empty activity.newLocation}">
                <input type="hidden" name="newLocationId" value="${locsQ.rows[0].id}">
                <input type="hidden" name="newLocationReason" value="${newLocationReason}">
            </c:when>
            <c:otherwise>
                <td>
                <select name="newLocationId">
                    <option value="" selected disabled>Pick a new location</option>
                    <c:forEach var="loc" items="${locsQ.rows}">
                        <option value="${loc.id}"><c:out value="${loc.siteName}:${loc.name}"/></option>
                    </c:forEach>
                </select>
                Reason: <input type="text" name="newLocationReason" value="${newLocationReason}">
                </td>
            </c:otherwise>
        </c:choose>
    </c:if>

    <c:if test="${activity.setsStatus != 0 && empty activity.newHardwareStatusId}">
        <td>
        <traveler:getAvailableStates var="statesQ" hardwareId="${activity.hardwareId}"/>
        <select name="hardwareStatusId" required>
            <option value="" selected disabled>Pick a new status</option>
            <c:forEach var="sRow" items="${statesQ.rows}">
                <option value="${sRow.id}"><c:out value="${sRow.name}"/></option>
            </c:forEach>
        </select>
        Reason: <input type="text" name="newStatusReason" value="Set by traveler step">
        </td>
    </c:if>

    <c:if test="${empty activity.genericLabelId}">
        <sql:query var="objectTypeQ">
            select id from Labelable where name='hardware';
        </sql:query>
        <c:set var="objectTypeId" value="${objectTypeQ.rows[0].id}" />

        <c:if test="${activity.removesLabel != 0}">
            <td>
            <traveler:getSetGenericLabels var="statesQ" objectId="${activity.hardwareId}" objectTypeId="${objectTypeId}"/>
             <select name="removeLabelId" required>
                <option value="" selected disabled>Pick a label to remove</option>
                <option value="0">No Label</option>
                <c:forEach var="sRow" items="${statesQ.rows}">
                    <option value="${sRow.theLabelId}"><c:out value="${sRow.labelGroupName}:${sRow.labelName}"/></option>
                </c:forEach>        
            </select>
            <input type="text" name="removeLabelReason" value="Removed by traveler step">
            </td>
        </c:if>

        <c:if test="${activity.addsLabel != 0}">
            <sql:query var="hardwareGroupsQ">
               call generic_hardwareGroups(?, ?)
               <sql:param value="${activity.hardwareId}"/>
               <sql:param value="${objectTypeId}"/>
            </sql:query>

            <sql:query var="subsysIdQ">
               call generic_subsystem(?, ?)
               <sql:param value="${activity.hardwareId}"/>
               <sql:param value="${objectTypeId}"/>
            </sql:query>
            <c:set var="subsysId" value="${subsysIdQ.rows[0].subsystemId}" />
            <td>
            <traveler:getUnsetGenericLabels var="statesQ" objectId="${activity.hardwareId}" objectTypeId="${objectTypeId}"
                                            subsysId="${subsysId}" hgResult="${hardwareGroupsQ}"/>
            <select name="addLabelId" required>
                <option value="" selected disabled>Pick a label to add</option>
                <option value="0">No Label</option>
                <c:forEach var="sRow" items="${statesQ.rows}">
                    <option value="${sRow.id}"><c:out value="${sRow.labelGroupName}:${sRow.labelName}"/></option>
                </c:forEach>        
            </select>
            <input type="text" name="addLabelReason" value="Applied by traveler step">
            </td>
        </c:if>
    </c:if>
</tr></table>
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
            <form method="get" action="supervisor/doNCR.jsp" target="_top">
                <input type="hidden" name="freshnessToken" value="${freshnessToken}">
                <input type="hidden" name="activityId" value="${activityId}">
                <INPUT TYPE=SUBMIT value="NCR"
                   <c:if test="${isTop || ! active}">disabled</c:if>>
            </form>
        </td>
    </tr>
</table>
