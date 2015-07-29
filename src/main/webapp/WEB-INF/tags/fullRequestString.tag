<%-- 
    Document   : fullRequestString
    Created on : Jul 29, 2015, 1:29:11 PM
    Author     : focke
--%>

<%@tag description="return the full request string for the current page" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="requestString" scope="AT_BEGIN"%>

<c:url var="requestString" value="${pageContext.request.requestURL}">
    <c:forEach var="paramName" items="${pageContext.request.parameterNames}">
        <c:forEach var="paramValue" items="${pageContext.request.parameterMap[paramName]}">
           <c:param name="${paramName}" value="${paramValue}"/>
        </c:forEach>
    </c:forEach>
</c:url>
