<%-- 
    Document   : test
    Created on : Oct 2, 2013, 3:53:56 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <c:out value="x ${pageScope.javax.servlet.jsp.jspRequest.uri} x"/>
<%--        <% request.setAttribute("url", request.getRequestURI()); %>--%>
        <c:out value="${url}"/> 
        <c:out value="${pageContext.request.requestURI}"/>
        <h2>page</h2>
<c:forEach var="v" items="${pageScope}">
        <c:out value="${v.key} ---- ${v.value}"/><br>
</c:forEach>        
        <h2>request</h2>
<c:forEach var="v" items="${requestScope}">
        <c:out value="${v.key} ---- ${v.value}"/><br>
</c:forEach>        
        <h2>session</h2>
<c:forEach var="v" items="${sessionScope}">
        <c:out value="${v.key} ---- ${v.value}"/><br>
</c:forEach>        
        <h2>application</h2>
<c:forEach var="v" items="${applicationScope}">
        <c:out value="${v.key} ---- ${v.value}"/><br>
</c:forEach>        
    </body>
</html>
