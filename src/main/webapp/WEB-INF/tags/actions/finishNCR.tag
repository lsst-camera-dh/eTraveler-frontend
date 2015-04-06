<%-- 
    Document   : finishNCR
    Created on : Jul 29, 2014, 2:39:42 PM
    Author     : focke
--%>

<%@tag description="Do surgery on a traveler instance so the return step will be current" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="ncrActivityId" required="true"%>
<%@attribute name="varNew" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="varNew" alias="activityId" scope="AT_BEGIN"%>
<%@attribute name="varTrav" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="varTrav" alias="travelerId" scope="AT_BEGIN"%>

<sql:query var="exceptionQ">
    select
        *,
        E.id as exceptionId
    from
        Exception E
        inner join ExceptionType ET on ET.id=E.exceptionTypeId
    where
        E.NCRActivityId=?<sql:param value="${ncrActivityId}"/>
    ;
</sql:query>
<c:choose>
    <c:when test="${fn:length(exceptionQ.rows) != 1}">
        Inconceivable! #253795
    </c:when>
    <c:otherwise>
        <c:set var="exception" value="${exceptionQ.rows[0]}"/>
    </c:otherwise>
</c:choose>

<traveler:findTraveler activityId="${exception.exitActivityId}" var="travelerId"/>
<sql:query var="activityQ">
    select * from Activity where id=?<sql:param value="${travelerId}"/>;
</sql:query>
<c:set var="traveler" value="${activityQ.rows[0]}"/>

<traveler:expandProcess processId="${traveler.processId}" var="processSteps"/>
<c:forEach items="${processSteps}" var="step">
    <c:if test="${step.edgePath == exception.returnProcessPath}">
        <c:set var="processId" value="${step.processId}"/>
        <c:set var="processEdgeId" value="${step.processEdgeId}"/>
    </c:if>
</c:forEach>

<traveler:childActivities activityId="${travelerId}" varAc="acList" varEx="exList"/>
<traveler:trimPath inPath="${exception.returnProcessPath}" var="parentEdgePath"/>
<c:set var="parentEdgePath" value="${empty parentEdgePath ? '' : parentEdgePath}"/>
<c:forEach items="${acList}" var="step">
    <c:set var="edgePath" value="${empty step.edgePath ? '' : step.edgePath}"/>
    <traveler:isStopped activityId="${step.activityId}" var="isStopped"/>
    <c:choose>
        <c:when test="${edgePath == parentEdgePath}">
            yes<br>
            <c:set var="parentActivityId" value="${step.activityId}"/>
            <c:set var="hardwareId" value="${step.hardwareId}"/>
            <c:set var="inNCR" value="${step.inNCR}"/>
        </c:when>
        <c:when test="${isStopped && fn:startsWith(edgePath, parentEdgePath)}">
            <ta:ncrExitActivity activityId="${step.activityId}"/>
        </c:when>
    </c:choose>
</c:forEach>

<ta:resumeActivity activityId="${travelerId}"/>

<ta:createActivity var="activityId"
    hardwareId="${hardwareId}"
    processId="${processId}"
    parentActivityId="${parentActivityId}"
    processEdgeId="${processEdgeId}"
    inNCR="${inNCR}"/>

<sql:update>
    update Exception set returnActivityId=?<sql:param value="${activityId}"/> 
    where id=?<sql:param value="${exception.exceptionId}"/>
</sql:update>
