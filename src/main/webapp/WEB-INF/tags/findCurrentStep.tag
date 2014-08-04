<%-- 
    Document   : findCurrentStep
    Created on : Jul 29, 2014, 2:39:30 PM
    Author     : focke
--%>

<%@tag description="Figure out the current step of a traveler instance" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="stepList" required="true" type="java.util.List"%>
<%@attribute name="varStepLink" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="varStepLink" alias="currentStepLink" scope="AT_BEGIN"%>
<%@attribute name="varStepEPath" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="varStepEPath" alias="currentStepEPath" scope="AT_BEGIN"%>

<c:set var="firstUninstantiated" value="0"/>
<c:set var="lastStopped" value="0"/>
<c:set var="lastUnfinished" value="0"/>
<c:set var="unstarted" value="0"/>

<%-- Need to deal with superceded Activities --%>

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
            </c:if>
            <c:if test="${empty step.begin}">
                <c:if test="${unstarted != 0}">
                    <c:set var="error" value="Too many unstarted steps"/>
                </c:if>
                <c:set var="unstarted" value="${step.activityId}"/>
                <c:set var="usPath" value="${step.edgePath}"/>
            </c:if>
            <c:if test="${empty step.end}">
                <c:set var="lastUnfinished" value="${step.activityId}"/>
                <c:set var="lufPath" value="${step.edgePath}"/>
            </c:if>
        </c:when>
        <c:otherwise>
            <c:if test="${firstUninstantiated == 0}">
                <c:if test="${step.parentActivityId == lastUnfinished}">
                    <c:set var="firstUninstantiated" value="${step.processId}"/>
                    <c:set var="processEdgeId" value="${step.processEdgeId}"/>
                    <c:set var="fuPath" value="${step.edgePath}"/>
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
    </c:when>
    <c:when test="${unstarted != 0}">
        <c:set var="mode" value="activity"/>
        <c:set var="theId" value="${unstarted}"/>
        <c:set var="currentStepEPath" value="${usPath}"/>
    </c:when>
    <c:when test="${lastUnfinished != 0}">
        <c:choose>
            <c:when test="${firstUninstantiated != 0}">
                <c:set var="mode" value="process"/>
                <c:set var="theId" value="${firstUninstantiated}"/>
                <c:set var="currentStepEPath" value="${fuPath}"/>
            </c:when>
            <c:otherwise>
               <c:set var="mode" value="activity"/>
               <c:set var="theId" value="${lastUnfinished}"/>
               <c:set var="currentStepEPath" value="${lufPath}"/>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <c:set var="mode" value="activity"/>
        <c:set var="theId" value="${topActivityId}"/>
        <c:set var="currentStepEPath" value=""/>
    </c:otherwise>
</c:choose>

<c:choose>
    <c:when test="${mode == 'activity'}">
        <c:url var="currentStepLink" value="activityPane.jsp">
            <c:param name="activityId" value="${theId}"/>
            <c:param name="topActivityId" value="${topActivityId}"/>
        </c:url>
    </c:when>
    <c:when test="${mode == 'process'}">
        <c:set var="processUrl" value="${autoStart ? 'fh/createActivity.jsp' : 'processPane.jsp'}"/>
        <c:url var="processLink" value="${processUrl}">
            <c:param name="processId" value="${theId}"/>
            <c:param name="topActivityId" value="${topActivityId}"/>
            <c:param name="harwareId" value="${hardwareId}"/>
            <c:param name="inNCR" value="${inNCR}"/>
            <c:param name="parentActivityId" value="${lastUnfinished}"/>
            <c:param name="processEdgeId" value="${processEdgeId}"/>
        </c:url>
        <c:choose>
            <c:when test="${autoStart}">
                <c:redirect url="${processLink}"/>
            </c:when>
            <c:otherwise>
                <c:set var="currentStepLink" value="${processLink}"/>
            </c:otherwise>
        </c:choose>
    </c:when>
</c:choose>