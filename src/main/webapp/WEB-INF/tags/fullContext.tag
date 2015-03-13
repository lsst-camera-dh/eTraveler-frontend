<%-- 
    Document   : fullContext
    Created on : Oct 29, 2014, 3:27:05 PM
    Author     : focke
--%>

<%@tag description="Figure out the context of the current page" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="fullContext" scope="AT_BEGIN"%>

<c:set var="fullContext" 
       value="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}"/>
