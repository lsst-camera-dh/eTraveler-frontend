<%-- 
    Document   : findCurrentStep
    Created on : Jul 29, 2014, 2:39:30 PM
    Author     : focke
--%>

<%@tag description="Figure out the current step of a traveler instance, creating the next Activity if that's what needs to happen." pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="stepList" required="true" type="java.util.List"%>
<%@attribute name="scriptMode"%>

<%@attribute name="varStepLink" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="varStepLink" alias="currentStepLink" scope="AT_BEGIN"%>
<%@attribute name="varStepEPath" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="varStepEPath" alias="currentStepEPath" scope="AT_BEGIN"%>
<%@attribute name="varStepId" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="varStepId" alias="currentStepActivityId" scope="AT_BEGIN"%>

<c:if test="${empty scriptMode}">
    <%-- If this is set, we don't redirect on Activity creation,
    and stuff the current activityId in currentStepActivityId just like usual. --%>
    <c:set var="scriptMode" value="false"/>
</c:if>

<c:set var="firstUninstantiated" value="0"/>
<c:set var="lastStopped" value="0"/>
<c:set var="lastUnfinished" value="0"/>
<c:set var="unstarted" value="0"/>

<c:set var="traveler" value="${stepList[0]}"/>
<c:set var="topActivityId" value="${traveler.activityId}"/>
<c:set var="hardwareId" value="${traveler.hardwareId}"/>
<c:set var="inNCR" value="${traveler.inNCR}"/>

<c:forEach var="step" varStatus="stepStat" items="${stepList}">
    <c:choose>
        <c:when test="${! empty step.activityId}">
            <c:if test="${step.statusName == 'stopped'}">
                <c:set var="lastStopped" value="${step.activityId}"/>
                <c:set var="lsPath" value="${step.edgePath}"/>
                <c:set var="lsStep" value="${step.stepPath}"/>
            </c:if>
            <c:if test="${empty step.begin}">
                <c:if test="${unstarted != 0}">
                    <traveler:error message="Too many unstarted steps ${unstarted} ${step.activityId}" bug="true"/>
                </c:if>
                <c:set var="unstarted" value="${step.activityId}"/>
                <c:set var="usPath" value="${step.edgePath}"/>
                <c:set var="usStep" value="${step.stepPath}"/>
            </c:if>
            <c:if test="${empty step.end}">
                <c:set var="lastUnfinished" value="${step.activityId}"/>
                <c:set var="lufPath" value="${empty step.edgePath ? '' : step.edgePath}"/>
                <c:set var="lufSubSteps" value="${step.subSteps}"/>
                <c:set var="lufStep" value="${step.stepPath}"/>
            </c:if>
        </c:when>
        <c:otherwise>
            <c:if test="${firstUninstantiated == 0}">
                <traveler:trimPath inPath="${step.edgePath}" var="parentPath"/>
                <c:if test="${parentPath == lufPath}">
                    <c:set var="firstUninstantiated" value="${step.processId}"/>
                    <c:set var="processEdgeId" value="${step.processEdgeId}"/>
                    <c:set var="fuPath" value="${step.edgePath}"/>
                    <c:set var="fuStep" value="${step.stepPath}"/>
                </c:if>
            </c:if>
        </c:otherwise>
    </c:choose>
</c:forEach>

<c:choose>
    <c:when test="${lastStopped != 0}">
        <c:set var="mode" value="activity"/>
        <c:set var="theId" value="${lastStopped}"/>
        <c:set var="currentStepEPath" value="${lsPath}"/>
        <c:set var="theStep" value="${lsStep}"/>
    </c:when>
    <c:when test="${unstarted != 0}">
        <c:set var="mode" value="activity"/>
        <c:set var="theId" value="${unstarted}"/>
        <c:set var="currentStepEPath" value="${usPath}"/>
        <c:set var="theStep" value="${usStep}"/>
    </c:when>
    <c:when test="${lastUnfinished != 0}">
        <c:choose>
            <c:when test="${firstUninstantiated != 0 && lufSubSteps != 'SELECTION' && lufSubSteps != 'HARDWARE_SELECTION'}">
                <c:set var="mode" value="process"/>
                <c:set var="theId" value="${firstUninstantiated}"/>
                <c:set var="currentStepEPath" value="${fuPath}"/>
                <c:set var="theStep" value="${fuStep}"/>
            </c:when>
            <c:otherwise>
               <c:set var="mode" value="activity"/>
               <c:set var="theId" value="${lastUnfinished}"/>
               <c:set var="currentStepEPath" value="${lufPath}"/>
               <c:set var="theStep" value="${lufStep}"/>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <c:set var="mode" value="activity"/>
        <c:set var="theId" value="${topActivityId}"/>
        <c:set var="currentStepEPath" value=""/>
        <c:set var="theStep" value=""/>
    </c:otherwise>
</c:choose>

<c:choose>
    <c:when test="${mode == 'activity'}">
        <c:url var="currentStepLink" value="activityPane.jsp">
            <c:param name="activityId" value="${theId}"/>
            <c:param name="topActivityId" value="${topActivityId}"/>
            <c:param name="step" value="${theStep}"/>
            <c:param name="isCurrent" value="CURRENT"/>
        </c:url>
        <c:set var="currentStepActivityId" value="${theId}"/>
    </c:when>
    <c:when test="${mode == 'process'}">
        <c:url var="processLink" value="processPane.jsp">
            <c:param name="processId" value="${theId}"/>
            <c:param name="topActivityId" value="${topActivityId}"/>
            <c:param name="hardwareId" value="${hardwareId}"/>
            <c:param name="inNCR" value="${inNCR}"/>
            <c:param name="parentActivityId" value="${lastUnfinished}"/>
            <c:param name="processEdgeId" value="${processEdgeId}"/>
            <c:param name="step" value="${theStep}"/>
            <c:param name="isCurrent" value="CURRENT"/>
        </c:url>
        <c:choose>
            <c:when test="${scriptMode}">
                <ta:createActivity var="currentStepActivityId" hardwareId="${hardwareId}" processId="${theId}"
                    inNCR="${inNCR}" parentActivityId="${lastUnfinished}" processEdgeId="${processEdgeId}"/>
            </c:when>
            <c:otherwise>
                <c:set var="currentStepLink" value="${processLink}"/>
                <c:set var="currentStepActivityId" value="-1"/>
            </c:otherwise>
        </c:choose>
    </c:when>
</c:choose>