<%-- 
    Document   : labelAdminWidget
    Created on : Apr 5, 2017, 3:07:48 PM
    Author     : focke
--%>

<%@tag description="Administer generic labels" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<traveler:fullRequestString var="thisPage"/>
<traveler:checkPerm var="mayAdmin" groups="EtravelerAllAdmin"/>

    <sql:query var="labelableQ">
select id, name from Labelable order by name;
    </sql:query>

    <sql:query var="subsysQ">
select id, name from Subsystem order by name;
    </sql:query>

    <sql:query var="hardwareGroupQ">
select id, name from HardwareGroup order by name;
    </sql:query>

<form action="admin/addLabelGroup.jsp">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
    <input type="hidden" name="referringPage" value="${thisPage}">
    Name: <input name="name">
    Description: <textarea name="description" required></textarea>
    <select name="labelableId" required>
        <option value="" selected disabled>Applicable Entities</option>
        <c:forEach var="labelable" items="${labelableQ.rows}">
            <option value="${labelable.Id}">${labelable.name}</option>
        </c:forEach>
    </select>
    <select name="subsysId">
        <option value="" selected>Subsystem (Optional)</option>
        <c:forEach var="subsys" items="${subsysQ.rows}">
            <option value="${subsys.Id}">${subsys.name}</option>
        </c:forEach>
    </select>
    <select name="hGroupId">
        <option value="" selected>Hardware Group (Optional)</option>
        <c:forEach var="hGroup" items="${hardwareGroupQ.rows}">
            <option value="${hGroup.Id}">${hGroup.name}</option>
        </c:forEach>
    </select>
    <input type="submit" value="Add New Label Group"
           <c:if test="${! mayAdmin}">disabled</c:if>>
</form>


   <sql:query var="groupsQ">
select LG.id, LG.name, LA.name as labelableName
from LabelGroup LG
inner join Labelable LA on LA.id = LG.labelableId
;
   </sql:query>

<form action="admin/addGenericLabelType.jsp">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
    <input type="hidden" name="referringPage" value="${thisPage}">
    Name: <input name="name">
    Description: <textarea name="description" required></textarea>
    <select name="groupId" required>
        <option value="0" selected disabled>Label Group</option>
        <c:forEach var="group" items="${groupsQ.rows}">
            <option value="${group.Id}">${group.labelableName}: ${group.name}</option>
        </c:forEach>
    </select>
    <input type="submit" value="Add New Label Type"
           <c:if test="${! mayAdmin}">disabled</c:if>>
</form>
