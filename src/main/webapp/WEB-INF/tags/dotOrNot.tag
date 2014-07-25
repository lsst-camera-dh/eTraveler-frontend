<%-- 
    Document   : dotOrNot
    Created on : Jul 25, 2014, 12:42:03 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="prefix"%>
<%@attribute name="sep"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="myPrefix" scope="AT_BEGIN"%>

<c:if test="${empty sep}">
    <c:set var="sep" value="."/>
</c:if>

<c:choose>
    <c:when test="${empty prefix}">
        <c:set var="myPrefix" value=""/>
    </c:when>
    <c:otherwise>
        <c:set var="myPrefix" value="${prefix}${sep}"/>
    </c:otherwise>
</c:choose>
