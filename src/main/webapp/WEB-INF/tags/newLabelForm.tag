<%-- 
    Document   : labelAdminWidget
    Created on : Apr 5, 2017, 3:07:48 PM
    Author     : focke
--%>

<%@tag description="Administer generic labels" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="labelGroupId"%>

<traveler:fullRequestString var="thisPage"/>
<traveler:checkPerm var="mayAdmin" groups="EtravelerAllAdmin"/>

   <sql:query var="groupsQ">
select LG.id, LG.name, LA.name as labelableName
from LabelGroup LG
inner join Labelable LA on LA.id = LG.labelableId
<c:if test="${! empty labelGroupId}">where LG.id = ?<sql:param value="${labelGroupId}"/></c:if>
;
   </sql:query>

<form action="admin/addGenericLabelType.jsp">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
    <input type="hidden" name="referringPage" value="${thisPage}">
    Name: <input name="name">
    Description: <textarea name="description" required></textarea>
    <c:choose>
        <c:when test="${empty labelGroupId}">
            <select name="groupId" required>
                <option value="0" selected disabled>Label Group</option>
                <c:forEach var="group" items="${groupsQ.rows}">
                    <option value="${group.Id}">${group.labelableName}: ${group.name}</option>
                </c:forEach>
            </select>
        </c:when>
        <c:otherwise>
            <input type="hidden" name="groupId" value="${labelGroupId}">
            Label Group: ${groupsQ.rows[0].name}
        </c:otherwise>
    </c:choose>
    <input type="submit" value="Add New Label Type"
           <c:if test="${! mayAdmin}">disabled</c:if>>
</form>
