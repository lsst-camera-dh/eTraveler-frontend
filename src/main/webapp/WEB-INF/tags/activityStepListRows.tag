<%-- 
    Document   : processStepListRows
    Created on : Jul 24, 2014, 11:43:14 AM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>
<%@attribute name="stepPrefix"%>
<%@attribute name="edgePrefix"%>
<%@attribute name="processPrefix"%>

<traveler:dotOrNot var="myStepPrefix" prefix="${stepPrefix}"/>
<traveler:dotOrNot var="myEdgePrefix" prefix="${edgePrefix}"/>
<traveler:dotOrNot var="myProcessPrefix" prefix="${processPrefix}"/>

<sql:query var="childrenQ" >
    select
    Ap.hardwareId, Ap.inNCR,
    P.id as processId, P.name, P.hardwareRelationshipTypeId, P.substeps,
    P.travelerActionMask&(select maskBit from InternalAction where name='async') as isAsync,
    PE.id as processEdgeId, PE.step,
    Ac.id as activityId, Ac.begin, Ac.end,
    AFS.name as statusName,
    JSH.id as jobStepId,
    concat('${myStepPrefix}', PE.step) as stepPath,
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
    Ap.id=?<sql:param value="${activityId}"/>
    group by PE.id, Ac.id
    order by abs(PE.step), Ac.iteration;
</sql:query>

<c:forEach var="cRow" items="${childrenQ.rows}">
    <c:set var="cRowJsp" value="${cRow}" scope="request"/>
    <%
        ((java.util.List)request.getAttribute("stepList")).add(request.getAttribute("cRowJsp"));
    %>
    <c:if test="${cRow.substeps != 'NONE'}">
        <c:choose>
            <c:when test="${empty cRow.activityId or empty cRow.begin}">
                <traveler:processStepListRows processId="${cRow.processId}" 
                                              stepPrefix="${cRow.stepPath}"
                                              edgePrefix="${cRow.edgePath}"
                                              processPrefix="${cRow.processPath}"/>
            </c:when>
            <c:otherwise>
                <traveler:activityStepListRows activityId="${cRow.activityId}" 
                                               stepPrefix="${cRow.stepPath}"
                                               edgePrefix="${cRow.edgePath}"
                                               processPrefix="${cRow.processPath}"/>
            </c:otherwise>
        </c:choose>
    </c:if>
</c:forEach>