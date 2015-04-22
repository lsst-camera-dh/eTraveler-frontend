<%-- 
    Document   : error
    Created on : Mar 2, 2015, 3:41:46 PM
    Author     : focke
--%>

<%@tag description="Do error reports" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@attribute name="message"%>
<%@attribute name="bug"%>

<c:if test="${empty bug}">
    <c:set var="bug" value="false"/>
</c:if>

<c:url var="errorPage" value="/error.jsp" context="/">
    <c:param name="message" value="${message}"/>
    <c:param name="bug" value="${bug}"/>
</c:url>
<c:redirect url="${errorPage}"/>
