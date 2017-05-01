<%-- 
    Document   : showStepsTable
    Created on : Jul 29, 2014, 12:52:40 PM
    Author     : focke
--%>

<%@tag description="Display traveler steps using a table" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>

<%@attribute name="stepList" required="true" type="java.util.List"%>
<%@attribute name="mode" required="true"%>
<%@attribute name="currentStepLink"%>
<%@attribute name="currentStepEPath"%>
<%@attribute name="currentStepActivityId"%>

<display:table id="step" name="${stepList}" class="datatable">
    <display:column title="Step">
        <c:if test="${! empty step.stepPath}">
        <c:choose>
            <c:when test="${mode == 'activity'}">
                <c:out value="${step.stepPath}"/>
            </c:when>
            <c:otherwise>
                <c:url var="drilldownLink" value="displayProcess.jsp">
                    <c:param name="processPath" value="${step.processPath}"/>
                </c:url>                
                <a href="${drilldownLink}"><c:out value="${step.stepPath}"/></a>
            </c:otherwise>
        </c:choose>
        </c:if>
    </display:column>
    <display:column title="Description">
        <c:set var="contentLabel" value="${step.shortDescription}"/>
        <c:choose>
            <c:when test="${! empty currentStepLink 
                            && (step.edgePath == currentStepEPath 
                            || (empty step.edgePath && empty currentStepEPath))
                            && (step.activityId == currentStepActivityId 
                                || (currentStepActivityId == -1 && empty step.activityId)
                                )}">
                <c:set var="contentLink" value="${currentStepLink}"/>
                <c:set var="contentLabel" value="${contentLabel} CURRENT STEP"/>
            </c:when>
            <c:when test="${mode == 'activity' && ! empty step.activityId}">
                <c:url var="contentLink" value="activityPane.jsp">
                    <c:param name="activityId" value="${step.activityId}"/>
                    <c:param name="step" value="${step.stepPath}"/>
                </c:url>
            </c:when>
            <c:otherwise>
                <c:url var="contentLink" value="processPane.jsp">
                    <c:param name="processId" value="${step.processId}"/>
                    <c:param name="step" value="${step.stepPath}"/>
                </c:url>                
            </c:otherwise>
        </c:choose>
        <a href="${contentLink}" target="content"><c:out value="${contentLabel}"/></a>
    </display:column><
    <c:if test="${mode == 'activity'}">
        <%--<display:column property="activityId"/>--%>
        <display:column property="begin"/>
        <display:column property="end"/>
        <display:column property="statusName" title="Status"/>
    </c:if>
</display:table>
