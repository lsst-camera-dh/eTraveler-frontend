<%-- 
    Document   : trimPath
    Created on : Sep 30, 2014, 4:34:23 PM
    Author     : focke
--%>

<%@tag description="remove the last element from a path" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@attribute name="inPath" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="outPath" scope="AT_BEGIN"%>
<%@attribute name="delims"%>

<c:if test="${empty delims}">
    <c:set var="delims" value="."/>
</c:if>

<c:set var="outPath" value=""/>
<c:forTokens items="${inPath}" delims="${delims}" var="component" varStatus="status">
    <c:if test="${! status.last}">
        <c:if test="${! status.first}">
            <c:set var="outPath" value="${outPath}${delims}"/>
        </c:if>
        <c:set var="outPath" value="${outPath}${component}"/>
    </c:if>
</c:forTokens>
