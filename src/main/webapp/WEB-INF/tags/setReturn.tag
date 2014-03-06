<%-- 
    Document   : setReturn
    Created on : Mar 4, 2014, 3:45:13 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="extra"%>

<c:set var="queryString" value="${pageContext.request.getQueryString()}"/>
<c:if test="${! empty queryString}">
    <c:set var="qqs" value="?${queryString}"/>
</c:if>

<c:set var="returnTo" value="${pageContext.request.getRequestURL()}${qqs}${extra}" scope="request"/>
