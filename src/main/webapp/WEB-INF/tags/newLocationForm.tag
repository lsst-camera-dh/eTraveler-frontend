<%-- 
    Document   : newLocationForm
    Created on : Apr 2, 2015, 9:18:52 PM
    Author     : focke
--%>

<%@tag description="Shaow a form to add a location" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="siteId"%>

<traveler:checkPerm var="mayAdmin" group="EtravelerAdmin"/>

<sql:query var="sitesQ" >
    select id, name from Site
    <c:if test="${! empty siteId}">where id=?<sql:param value="${siteId}"/></c:if>
    order by name;
</sql:query>
    
<form method="get" action="fh/addLocation.jsp">
    <input type="submit" value="Add Location"
       <c:if test="${! mayAdmin}">disabled</c:if>>
    Name: <input type="text" name="name" required>
    Site: 
    <c:choose>
        <c:when test="${empty siteId}">
            <select name="siteId">
                <c:forEach var="row" items="${sitesQ.rows}">
                    <option value="${row.id}" <c:if test="${preferences.siteName==row.name}">selected</c:if>>${row.name}</option>
                </c:forEach>
            </select>
        </c:when>
        <c:otherwise>
            <input type="hidden" name="siteId" value="${siteId}">
            <c:out value="${sitesQ.rows[0].name}"/>
        </c:otherwise>
    </c:choose>
</form>
