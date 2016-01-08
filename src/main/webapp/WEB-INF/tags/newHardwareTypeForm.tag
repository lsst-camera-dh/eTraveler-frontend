<%-- 
    Document   : newHardwareTypeForm
    Created on : Jan 8, 2016, 12:06:06 PM
    Author     : focke
--%>

<%@tag description="Form for adding a new HardwareType" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<traveler:checkPerm var="mayAdmin" groups="EtravelerAdmin"/>

    <sql:query var="subsysQ">
select id, name from Subsystem;
    </sql:query>

<form method="get" action="admin/addHardwareType.jsp">
    <input type="submit" value="Add Hardware Type"
       <c:if test="${! mayAdmin}">disabled</c:if>>
    Name or Drawing #:&nbsp;<input type="text" name="name" required>
    Sequence width - set to zero if not automatic:&nbsp;<select name="width">
        <option value="0">0</option>
        <option value="1">1</option>
        <option value="2">2</option>
        <option value="3">3</option>
        <option value="4" selected>4</option>
        <option value="5">5</option>
    </select><br>
    Description:&nbsp;<input type="text" name="description">
    Batched?&nbsp;<input type="radio" name="isBatched" value="0" checked>No&nbsp;<input type="radio" name="isBatched" value="1">Yes<br>
    Subsystem:&nbsp;<select name="subsystemId" required>
        <option value="0" selected disabled>Select Subsystem</option>
        <c:forEach var="subsystem" items="${subsysQ.rows}">
            <option value="${subsystem.id}">${subsystem.name}</option>
        </c:forEach>
    </select>
</form>