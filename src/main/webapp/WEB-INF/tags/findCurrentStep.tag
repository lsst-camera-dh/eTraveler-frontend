<%-- 
    Document   : findCurrentStep
    Created on : Jul 29, 2014, 2:39:30 PM
    Author     : focke
--%>

<%@tag description="Figure out the current step of a traveler instance" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="stepList" required="true" type="java.util.List"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="currentStepLink" scope="AT_BEGIN"%>

<c:set var="firstUninstantiated" value="0"/>
<c:set var="lastStopped" value="0"/>
<c:set var="lastUnfinished" value="0"/>
<c:set var="unstarted" value="0"/>

<%-- Need to deal with superceded Activities --%>

<c:forEach var="step" varStatus="stepStat" items="${stepList}">
    <c:choose>
        <c:when test="${! empty step.activityId}">
            <c:if test="${step.statusName == 'stopped'}">
                <c:set var="lastStopped" value="${step.activityId}"/>
            </c:if>
            <c:if test="${empty step.begin}">
                <c:if test="${unstarted != 0}">
                    <c:set var="error" value="Too many unstarted steps"/>
                </c:if>
                <c:set var="unstarted" value="${step.activityId}"/>
            </c:if>
            <c:if test="${empty step.end}">
                <c:set var="lastUnfinished" value="${step.activityId}"/>
                <c:set var="lufEdgePath" value="${step.edgePath}"/>
            </c:if>
        </c:when>
        <c:otherwise>
            <c:if test="${firstUninstantiated == 0}">
                <%-- Need more testing to ensure this is a child of lastUnfinished --%>
                <traveler:isChild var="isChild" childEdgePath="${step.edgePath}" parentEdgePath="${lufEdgePath}"/>
                <c:if test="${isChild}">
                    <c:set var="firstUninstantiated" value="${step.processId}"/>
                </c:if>
            </c:if>
        </c:otherwise>
    </c:choose>
</c:forEach>

<c:choose>
    <c:when test="${lastStopped != 0}">
        <c:set var="currentStepLink" value="activity ${lastStopped}"/>
    </c:when>
    <c:when test="${unstarted != 0}">
        <c:set var="currentStepLink" value="activity ${unstarted}"/>
    </c:when>
    <c:when test="${lastUnfinished != 0}">
        <c:choose>
            <c:when test="${firstUninstantiated != 0}">
                <c:set var="currentStepLink" value="process ${firstUninstantiated}"/> 
            </c:when>
            <c:otherwise>
                <c:set var="currentStepLink" value="activity ${lastUnfinished}"/>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <c:set var="currentStepLink" value="activity ${stepList[0].activityId}"/>
    </c:otherwise>
</c:choose>
