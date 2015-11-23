<%-- 
    Document   : error
    Created on : Mar 2, 2015, 3:41:46 PM
    Author     : focke
--%>

<%@tag description="Do error reports" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@attribute name="message" required="true"%>
<%@attribute name="bug"%>

<c:if test="${empty bug}">
    <c:set var="bug" value="false"/>
</c:if>

<c:set var="contentType" value="<%=response.getContentType()%>"/>
<c:choose>
    <c:when test="${fn:containsIgnoreCase(contentType, 'json')}">
        <c:set var="errorPage" value="/error.json.jsp"/>
    </c:when>
    <c:otherwise>
        <c:set var="errorPage" value="/error.html.jsp"/>
    </c:otherwise>
</c:choose>

<c:url var="errorUrl" value="${errorPage}" context="/">
    <c:param name="message" value="${message}"/>
    <c:param name="bug" value="${bug}"/>
</c:url>
<c:redirect url="${errorUrl}"/>
