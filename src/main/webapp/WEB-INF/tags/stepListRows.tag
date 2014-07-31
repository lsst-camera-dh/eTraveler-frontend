<%-- 
    Document   : stepListRows
    Created on : Jul 24, 2014, 11:43:14 AM
    Author     : focke
--%>

<%@tag description="Add all rows but the first to the list created by stepList.tag" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="theId" required="true"%>
<%@attribute name="mode" required="true"%>
<%@attribute name="stepPrefix"%>
<%@attribute name="edgePrefix"%>
<%@attribute name="processPrefix" required="true"%>
<%@attribute name="theList" required="true" type="java.util.List"%>

<c:if test="${mode != 'activity' && mode != 'process'}">
    <%-- Should redirect to an error page here --%>
    Programmer error #606268
</c:if>

<traveler:dotOrNot var="myStepPrefix" prefix="${stepPrefix}"/>
<traveler:dotOrNot var="myEdgePrefix" prefix="${edgePrefix}"/>
<traveler:dotOrNot var="myProcessPrefix" prefix="${processPrefix}"/>

<sql:query var="childrenQ" >
    <c:choose>
        <c:when test="${mode == 'activity'}">
select
Ap.hardwareId, Ap.inNCR,
P.id as processId, P.name, P.hardwareRelationshipTypeId, P.substeps,
P.travelerActionMask&(select maskBit from InternalAction where name='async') as isAsync,
PE.id as processEdgeId, PE.step,
Ac.id as activityId, Ac.begin, Ac.end, Ac.parentActivityId, Ac.processEdgeId,
AFS.name as statusName,
JSH.id as jobStepId,
concat('${myStepPrefix}', abs(PE.step)) as stepPath,
concat('${myEdgePrefix}', PE.id) as edgePath,
concat('${myProcessPrefix}', P.id) as processPath
from
Activity Ap
inner join ProcessEdge PE on PE.parent=Ap.processId
inner join Process P on P.id=PE.child
left join Activity Ac on Ac.parentActivityId=Ap.id and Ac.processEdgeId=PE.id
left join ActivityFinalStatus AFS on AFS.id=Ac.activityFinalStatusId
left join JobStepHistory JSH on JSH.activityId=Ac.id
where
Ap.id=?<sql:param value="${theId}"/>
group by PE.id, Ac.id
order by abs(PE.step), Ac.iteration;
        </c:when>
        <c:when test="${mode == 'process'}">
select 
PE.child, PE.step, P.name, P.id as processId, P.substeps,
concat('${myStepPrefix}', abs(PE.step)) as stepPath,
concat('${myEdgePrefix}', PE.id) as edgePath,
concat('${myProcessPrefix}', P.id) as processPath
from ProcessEdge PE
inner join Process P on P.id=PE.child
where PE.parent=?<sql:param value="${theId}"/>
order by abs(PE.step);
        </c:when>
        <c:otherwise>
arglebargle #606268
        </c:otherwise>
    </c:choose>
</sql:query>

<c:forEach var="cRow" items="${childrenQ.rows}">
    <%
        ((java.util.List)jspContext.getAttribute("theList")).add(jspContext.getAttribute("cRow"));
    %>
    <c:if test="${cRow.substeps != 'NONE'}">
        <c:choose>
            <c:when test="${mode == 'process' || (mode == 'activity' && (empty cRow.activityId or empty cRow.begin))}">
                <traveler:stepListRows mode="process"
                    theList="${theList}"
                    theId="${cRow.processId}" 
                    stepPrefix="${cRow.stepPath}"
                    edgePrefix="${cRow.edgePath}"
                    processPrefix="${cRow.processPath}"/>
            </c:when>
            <c:otherwise>
                <traveler:stepListRows mode="activity"
                    theList="${theList}"
                    theId="${cRow.activityId}" 
                    stepPrefix="${cRow.stepPath}"
                    edgePrefix="${cRow.edgePath}"
                    processPrefix="${cRow.processPath}"/>
            </c:otherwise>
        </c:choose>
    </c:if>
</c:forEach>
