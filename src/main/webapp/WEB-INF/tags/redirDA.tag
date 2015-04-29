<%-- 
    Document   : redirDA
    Created on : Mar 14, 2014, 3:01:32 PM
    Author     : focke
--%>

<%@tag description="Redirect to the displayActivity page" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId"%>

<c:choose>
    <c:when test="${! empty activityId}">
        <c:set var="destActivityId" value="${activityId}"/>
    </c:when>
    <c:when test="${! empty param.topActivityId}">
        <c:set var="destActivityId" value="${param.topActivityId}"/>
    </c:when>
</c:choose>
    
<c:choose>
    <c:when test="${! empty destActivityId}">
        <c:url var="daStub" value="/displayActivity.jsp" context="/">
            <c:param name="activityId" value="${destActivityId}"/>
        </c:url>
        <c:set var="daLink" value="${daStub}#theFold"/>
        <c:redirect url="${daLink}"/>
    </c:when>
    <c:otherwise>
<traveler:error message="Oh dear.
Tell the developers you ran into bug #689743." bug="true"/>
    </c:otherwise>
</c:choose>