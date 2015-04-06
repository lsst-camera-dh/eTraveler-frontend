<%-- 
    Document   : error
    Created on : Mar 2, 2015, 3:41:46 PM
    Author     : focke
--%>

<%@tag description="Do error reports" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@attribute name="message"%>

<c:url var="errorPage" value="/error.jsp" context="/">
    <c:param name="message" value="${message}"/>
</c:url>
<c:redirect url="${errorPage}"/>
