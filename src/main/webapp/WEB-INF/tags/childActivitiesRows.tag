<%-- 
    Document   : childActivitiesRows
    Created on : Sep 23, 2014, 4:16:20 PM
    Author     : focke
--%>

<%@tag description="Add most rows to the lists created by childActivities" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="acList" required="true" type="java.util.List"%>
<%@attribute name="exList" required="true" type="java.util.List"%>
<%@attribute name="stepPrefix"%>
<%@attribute name="edgePrefix"%>
<%@attribute name="processPrefix" required="true"%>

<traveler:dotOrNot var="myStepPrefix" prefix="${stepPrefix}"/>
<traveler:dotOrNot var="myEdgePrefix" prefix="${edgePrefix}"/>
<traveler:dotOrNot var="myProcessPrefix" prefix="${processPrefix}"/>

<sql:query var="childQ">
    select
        A.id as activityId, A.begin, A.end, A.hardwareId, A.inNCR,
        P.id as processId, P.name, P.hardwareRelationshipTypeId, P.substeps, P.shortDescription,
        P.travelerActionMask&(select maskBit from InternalAction where name='async') as isAsync,
        PE.id as processEdgeId, PE.step,
        AFS.name as statusName,
        concat('${myStepPrefix}', abs(PE.step)) as stepPath,
        concat('${myEdgePrefix}', PE.id) as edgePath,
        concat('${myProcessPrefix}', P.id) as processPath,
        E.id as exceptionId
    from
        Activity A
        inner join Process P on P.id=A.processId
        inner join ProcessEdge PE on PE.id=A.processEdgeId
        inner join ActivityStatusHistory ASH on ASH.activityId=A.id and ASH.id=(select max(id) from ActivityStatusHistory where activityId=A.id)
        inner join ActivityFinalStatus AFS on AFS.id=ASH.activityStatusId
        left join Exception E on E.exitActivityId=A.id
    where
        A.parentActivityId=?<sql:param value="${activityId}"/>
    order by
        A.id
    ;
</sql:query>

<c:forEach items="${childQ.rows}" var="activity">
<%
    ((java.util.List)jspContext.getAttribute("acList")).add(jspContext.getAttribute("activity"));
%>                    
    <c:set var="exceptionId" value="${activity.exceptionId}"/>
    <c:if test="${! empty exceptionId}">
<%
    ((java.util.List)jspContext.getAttribute("exList")).add(jspContext.getAttribute("exceptionId"));
%>                    
    </c:if>
    <traveler:childActivitiesRows 
        activityId="${activity.activityId}" 
        acList="${acList}" 
        exList="${exList}"
        stepPrefix="${activity.stepPath}"
        edgePrefix="${activity.edgePath}"
        processPrefix="${activity.processPath}"/>
</c:forEach>
