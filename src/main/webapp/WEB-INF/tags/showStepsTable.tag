<%-- 
    Document   : showStepsTable
    Created on : Jul 29, 2014, 12:52:40 PM
    Author     : focke
--%>

<%@tag description="Display traveler steps using a table" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>

<%@attribute name="stepList" required="true" type="java.util.List"%>
<%@attribute name="mode" required="true"%>

<display:table id="step" name="${stepList}" class="datatable">
    <display:column title="Step">
        <c:if test="${! empty step.stepPath}">
        <c:choose>
            <c:when test="${mode == 'activity' && ! empty step.activityId}">
                <c:url var="drilldownLink" value="displayActivity.jsp">
                    <c:param name="activityId" value="${step.activityId}"/>
                </c:url>
            </c:when>
            <c:otherwise>
                <c:url var="drilldownLink" value="displayProcess.jsp">
                    <c:param name="processPath" value="${step.processPath}"/>
                </c:url>                
            </c:otherwise>
        </c:choose>
            <a href="${drilldownLink}">${step.stepPath}</a>
        </c:if>
    </display:column>
    <display:column title="Name">
        <c:choose>
            <c:when test="${mode == 'activity' && ! empty step.activityId}">
                <c:url var="contentLink" value="activityPane.jsp">
                    <c:param name="activityId" value="${step.activityId}"/>
                </c:url>
            </c:when>
            <c:otherwise>
                <c:url var="contentLink" value="processPane.jsp">
                    <c:param name="processId" value="${step.processId}"/>
                </c:url>                
            </c:otherwise>
        </c:choose>
        <a href="${contentLink}" target="content">${step.name}</a>
    </display:column><
    <c:if test="${mode == 'activity'}">
        <display:column property="begin"/>
        <display:column property="end"/>
        <display:column property="statusName"/>
    </c:if>
</display:table>
