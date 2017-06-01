<%-- 
    Document   : newJhForm
    Created on : Sep 17, 2015, 4:39:06 PM
    Author     : focke
--%>

<%@tag description="A form to add a new Job Harness install" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="siteId"%>

<traveler:fullRequestString var="thisPage"/>
<traveler:checkPerm var="mayAdmin" groups="EtravelerAllAdmin"/>

    <sql:query var="siteQ">
select id, name from Site
<c:if test="${! empty siteId}">where id=?<sql:param value="${siteId}"/></c:if>
;
    </sql:query>

<form method="get" action="admin/addJhInstall.jsp">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
    <input type="hidden" name="referringPage" value="${thisPage}">
    <input type="submit" value="Add JH Install"
           <c:if test="${! mayAdmin}">disabled</c:if>>
    Name: <input type="text" name="name" required="true">
    Description: <textarea name="description" required="true"></textarea>
    Site: <c:choose>
        <c:when test="${empty siteId}">
            <select name="siteId" required>
                <option value="" selected disabled>Pick a site</option>
                <c:forEach var="row" items="${siteQ.rows}">
                    <option value="${row.id}">${row.name}</option>
                </c:forEach>
            </select>
        </c:when>
        <c:otherwise>
            <input type="hidden" name="siteId" value="${siteQ.rows[0].id}"><c:out value="${siteQ.rows[0].name}"/>
        </c:otherwise>
    </c:choose>
    <br>
    jhVirtualEnv: <input type="text" name="jhVirtualEnv" required="true">
    jhOutputRoot: <input type="text" name="jhOutputRoot" required="true">
    jhStageRoot: <input type="text" name="jhStageRoot">
    jhCfg: <input type="text" name="jhCfg">
</form>