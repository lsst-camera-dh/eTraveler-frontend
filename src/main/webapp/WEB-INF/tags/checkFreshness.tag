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
    <traveler:error message="You have submitted a form from a stale page had ${formToken} needed ${freshnessToken}.
                    Please go back and reload the page."/>
</c:if>

<c:set var="freshnessToken" value="${freshnessGenerator.nextLong()}" scope="session"/>
