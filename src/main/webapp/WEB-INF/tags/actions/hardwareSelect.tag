<%-- 
    Document   : activitySelectionWidget
    Created on : Jan 15, 2014, 4:21:02 PM
    Author     : focke
--%>

<%@tag description="Handle selection steps" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

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
H.hardwareTypeId,
AFS.name as status
from Activity A
inner join Process P on P.id = A.processId
inner join Hardware H on H.id = A.hardwareId
inner join ActivityStatusHistory ASH on ASH.activityId=A.id and ASH.id=(select max(id) from ActivityStatusHistory where activityId=A.id)
inner join ActivityFinalStatus AFS on AFS.id=ASH.activityStatusId
where A.id=?<sql:param value="${activityId}"/>;
    </sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<c:if test="${activity.substeps == 'HARDWARE_SELECTION'
              && activity.status == 'inProgress'
              && mayOperate}"> <%-- Skip all the rest if not --%>

    <sql:query var="choicesQ">
select 
PE.child, PE.id as edgeId, PE.step, PE.branchHardwareTypeId,
Ac.creationTS
from Activity Ap
inner join ProcessEdge PE on PE.parent=Ap.processId
inner join Process P on P.id=PE.child
left join Activity Ac on Ac.parentActivityId=Ap.id and Ac.processEdgeId=PE.id
where Ap.id=?<sql:param value="${activityId}"/>;
    </sql:query>
<display:table name="${choicesQ.rows}"/>
<c:set var="numChosen" value="0"/>
<c:forEach items="${choicesQ.rows}" var="childRow" varStatus="child">
    <c:if test="${! empty childRow.creationTS}">
        <c:set var="numChosen" value="${numChosen + 1}"/>
    </c:if>
</c:forEach>

<%-- redirect if hardware selection not yet made--%>
<c:set var="doRedirect" value="${numChosen == 0}"/>
[${doRedirect}]
<c:if test="${doRedirect}">
    <c:set var="matchingBranch" value=""/>
    <c:set var="defaultBranch" value=""/>
    <c:forEach items="${choicesQ.rows}" var="childRow" varStatus="child">
        <c:choose>
            <c:when test="${empty childRow.branchHardwareTypeId}">
                <c:choose>
                    <c:when test="${empty defaultBranch}">
                        <c:set var="defaultBranch" value="${child.count}"/>
                    </c:when>
                    <c:otherwise>
                        <traveler:error message="Too many default branches."/>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:when test="${childRow.branchHardwareTypeId == activity.hardwareTypeId}">
                <c:choose>
                    <c:when test="${empty matchingBranch}">
                        <c:set var="matchingBranch" value="${child.count}"/>
                    </c:when>
                    <c:otherwise>
                        <traveler:error message="Too many matching branches."/>
                    </c:otherwise>
                </c:choose>                    
            </c:when>
        </c:choose>        
    </c:forEach>
    <c:choose>
        <c:when test="${! empty matchingBranch}">
            <c:set var="selectedBranch" value="${matchingBranch}"/>
        </c:when>
        <c:when test="${! empty defaultBranch}">
            <c:set var="selectedBranch" value="${defaultBranch}"/>
        </c:when>
        <c:otherwise>
            <traveler:error message="No matching hardware branch"/>
        </c:otherwise>
    </c:choose>
    <c:set var="selectedChild" value="${choicesQ.rows[selectedBranch - 1]}"/>
    ${selectedChild.name}
    
    <ta:createActivity hardwareId="${activity.hardwareId}" processId="${selectedChild.child}" 
                       parentActivityId="${activityId}" processEdgeId="${selectedChild.edgeId}"
                       inNCR="${activity.inNCR}"
                       var="childActivityId"/>
</c:if>

</c:if>
