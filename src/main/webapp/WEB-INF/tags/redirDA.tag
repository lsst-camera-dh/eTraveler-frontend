<%-- 
    Document   : redirDA
    Created on : Mar 14, 2014, 3:01:32 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
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
        Oh dear.
        Tell the developers you ran into bug #689743.
    </c:otherwise>
</c:choose>