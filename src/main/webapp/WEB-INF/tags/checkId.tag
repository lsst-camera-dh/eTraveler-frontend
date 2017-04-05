<%-- 
    Document   : checkId
    Created on : Mar 11, 2014, 4:12:21 PM
    Author     : focke
--%>

<%@tag description="Redirect to welcome page if id is not in specified table" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="table" required="true"%>
<%@attribute name="id" required="true"%>

<sql:query var="idQ">
    select id from ${table} where id = ?<sql:param value="${id}"/>
</sql:query>

<c:set var="nIds" value="${fn:length(idQ.rows)}"/>

<c:choose>
    <c:when test="${nIds == 0}">
        <traveler:error message="Id ${id} not found in table ${table}"/>
    </c:when>
    <c:when test="${nIds > 1}">
        <traveler:error message="Too many many rows (${nIds}) for id ${id} in table ${table}"/>
    </c:when>
</c:choose>

<c:if test="${idQ.rows[0].id != id}">
    <traveler:error message="Malformed id ${id} for table ${table}"/>
</c:if>