<%-- 
    Document   : checkFreshness
    Created on : Dec 2, 2015, 3:48:07 PM
    Author     : focke
--%>

<%@tag description="Check for stale forms" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="formToken" required="true"%>

<c:if test="${formToken != freshnessToken}">
    <traveler:error message="You have submitted a form from a stale page."/>
</c:if>

<c:choose>
    <c:when test="${empty freshnessToken}">
        <c:set var="freshnessToken" value="1" scope="session"/>
    </c:when>
    <c:otherwise>
        <c:set var="freshnessToken" value="${freshnessToken + 1}"/>
    </c:otherwise>
</c:choose>
