<%-- 
    Document   : finishNCR
    Created on : Jul 29, 2014, 2:39:42 PM
    Author     : focke
--%>

<%@tag description="Do surgery on a traveler instance so the return step will be current" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@attribute name="stepList" required="true" type="java.util.List"%>
<%@attribute name="returnEdgePath" required="true"%>

<c:set var="state" value="pre"/>

<c:forEach var="step" items="${stepList}">
    <%-- Handle state transitions --%>
    <c:choose>
        <c:when test="${state == 'pre'}">
            <c:choose>
                <c:when test="${step.edgePath == returnEdgePath}">
                    <c:set var="state" value="superceding"/>
                </c:when>
                <c:when test="${empty step.activityId}">
                    <c:set var="state" value="skipping"/>
                </c:when>
                <%-- what if both are true? --%>
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
            
        </c:when>
        <c:when test="${state == 'superceding'}">
            
        </c:when>
    </c:choose>
</c:forEach>
