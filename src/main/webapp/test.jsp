<%-- 
    Document   : test
    Created on : Oct 2, 2013, 3:53:56 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <traveler:setReturn extra="#foo"/>
        <h1>Hello World!</h1>
        <c:set var="mask" value="0"/>
        <c:forEach var="group" items="${paramValues.group}"><c:set var="mask" value="${mask + group}"/></c:forEach>
        ${mask}<br>
        [<c:out value="${pageScope.javax.servlet.jsp.jspRequest.uri}"/>]<br>
<%--        <% request.setAttribute("url", request.getRequestURI()); %>--%>
        [<c:out value="${url}"/>]<br>
        [<c:out value="${pageContext}"/>]<br>
        [<c:out value="${request}"/>]<br>
        [<c:out value="${pageContext.request}"/>]<br>
        [<c:out value="${pageContext.request.requestURI}"/>]<br>
        [${header}]<br>
        [${header.referer}]<br>
        [${header['Referer']}]<br>
        [${pageContext.request.getHeader("Referer")}]<br>
        [${pageContext.request.getRequestURL()}]<br>
        [${pageContext.request.getQueryString()}]<br>
        <br>
        [${appVariables.etravelerELogVersion}]
        <br>
        <c:url var="testLink" value="test.jsp">
            <c:param name="x" value="7"/>
        </c:url>
        <c:set var="tlPlusFrag" value="${testLink}#foo"/>
        <a href="${tlPlusFrag}">test</a>

        <c:set var="doRegister" value="${empty param.doRegister ? false : param.doRegister}"/>
        <c:if test="${doRegister}">
        regiter:
        <ta:registerFile filePath="/u/ek/focke/pix/warren.jpg" lsstId="123"/>
        i mean register
        </c:if>
        
        <traveler:test/>
        [${fnord}]
        
        <c:if test="${! empty param.activityId}">
            <traveler:findTraveler activityId="${param.activityId}" var="foof"/>
            [[ ${foof} ]]
            <traveler:findPath var="edgePath" activityId="${param.activityId}"/>
            {{ ${edgePath} }}
        </c:if>
        
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
