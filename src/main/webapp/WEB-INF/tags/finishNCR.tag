<%-- 
    Document   : finishNCR
    Created on : Jul 29, 2014, 2:39:42 PM
    Author     : focke
--%>

<%@tag description="Do surgery on a traveler instance so the return step will be current" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="stepList" required="true" type="java.util.List"%>
<%@attribute name="returnEdgePath" required="true"%>
<%@attribute name="ncrActivityId" required="true"%>

<c:set var="state" value="pre"/>

<c:forEach var="step" items="${stepList}">
    <%-- Handle state transitions --%>
    <c:choose>
        <%-- If exit and return are the same, do we supercede or reuse? --%>
        <c:when test="${state == 'pre'}">
            <c:choose>
                <c:when test="${step.edgePath == returnEdgePath && empty step.activityId}">
                    <c:set var="state" value="post"/>
                </c:when>
                <c:when test="${step.edgePath == returnEdgePath}">
                    <c:set var="state" value="superceding"/>
                </c:when>
                <c:when test="${empty step.activityId}">
                    <c:set var="state" value="skipping"/>
                </c:when>
            </c:choose>
        </c:when>
        <c:when test="${state == 'skipping'}">
            <c:if test="${step.edgePath == returnEdgePath}">
                <c:set var="state" value="post"/>
            </c:if>
        </c:when>
        <c:when test="${state == 'superceding'}">
            <c:if test="${empty step.activityId}">
                <c:set var="state" value="post"/>
            </c:if>
        </c:when>
        <c:when test="${state == 'post'}">
            <%-- nothing --%>
        </c:when>
        <c:otherwise>
            <%-- Should redirect to an error page here --%>
            Error #300518
        </c:otherwise>
    </c:choose>
            
    <%-- Take action if appropriate --%>
    <c:choose>
        <c:when test="${state == 'skipping'}">
            <%-- Create Activities, mark skipped if not ancestor of return point --%>
            <%-- Argh, no. Skip the first one, then redirect & start over --%>
            <c:if test="${! fn:startsWith(returnEdgePath, step.edgePath)}">
                <traveler:skipStep var="activityId"
                    processId="${step.processId}" hardwareId="${step.hardwareId}"
                    parentActivityId="${step.parentActivityId}" processEdgeId="${step.processEdgeId}"
                    inNCR="${step.inNCR}"/>
                <c:url var="ncrUrl" value="finishNCR.jsp">
                    <c:param name="activityId" value="${ncrActivityId}"/>
                </c:url>
                <c:redirect url="${ncrUrl}"/>
            </c:if>
        </c:when>
        <c:when test="${state == 'superceding'}">
            <%-- Mark all Activities superceded --%>
            <%-- Or do we? Do children of superceded steps get superceded?
            If not, do we need to reload again here? would reloading even work then? --%>
            <traveler:closeActivity activityId="${step.activityId}" status="Superceded"/>
        </c:when>
    </c:choose>
</c:forEach>
