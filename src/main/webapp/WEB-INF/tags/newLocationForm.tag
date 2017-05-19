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
<%@attribute name="parentId"%>

<traveler:checkPerm var="mayAdmin" groups="EtravelerAllAdmin"/>
<traveler:fullRequestString var="thisPage"/>

<sql:query var="sitesQ" >
    select id, name from Site
    <c:if test="${! empty siteId}">where id=?<sql:param value="${siteId}"/></c:if>
    order by name;
</sql:query>
<c:if test="${! empty siteId}">
    <c:set var="siteName" value="${sitesQ.rows[0].name}"/>
</c:if>

<c:if test="${! empty parentId}">
    <sql:query var="pareSiteQ">
select S.id, S.name
from Location L 
inner join Site S on S.id = L.siteId
where L.id = ?<sql:param value="${parentId}"/>
    </sql:query>
    <c:set var="pareSite" value="${pareSiteQ.rows[0]}"/>
    <c:choose>
        <c:when test="${! empty siteId}">
            <c:if test="${pareSite.id != siteId}">
                <traveler:error message="Site and parent location don't match"/>
            </c:if>
        </c:when>
        <c:otherwise>
            <c:set var="siteId" value="${pareSite.id}"/>
            <c:set var="siteName" value="${pareSite.name}"/>
        </c:otherwise>
    </c:choose>
</c:if>

<c:choose>
    <c:when test="${! empty parentId}">
        <c:set var="submitLabel" value="Add Child Location"/>
    </c:when>
    <c:otherwise>
        <c:set var="submitLabel" value="Add Location"/>
    </c:otherwise>
</c:choose>

<form method="get" action="admin/addLocation.jsp">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
    <input type="hidden" name="referringPage" value="${thisPage}">
    <input type="submit" value="${submitLabel}"
       <c:if test="${! mayAdmin}">disabled</c:if>>
    Name: <input type="text" name="name" required>
    Site: 
    <c:choose>
        <c:when test="${empty siteId}">
            <select name="siteId" required>
                <option value="" selected disabled>Pick a site</option>
                <c:forEach var="row" items="${sitesQ.rows}">
                    <option value="${row.id}" <c:if test="${preferences.siteName==row.name}">selected</c:if>>${row.name}</option>
                </c:forEach>
            </select>
        </c:when>
        <c:otherwise>
            <input type="hidden" name="siteId" value="${siteId}">
            <c:out value="${siteName}"/>
        </c:otherwise>
    </c:choose>
    <input type="hidden" name="parentId" value="${parentId}">
</form>
