<%-- 
    Document   : newRelationshipTypeform
    Created on : Sep 16, 2015, 9:47:30 AM
    Author     : focke
--%>

<%@tag description="A form to create new MultiRelationshipTypes" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<traveler:fullRequestString var="thisPage"/>
<traveler:checkPerm var="mayAdmin" groups="EtravelerAdmin"/>

<sql:query var="hardwareTypesQ" >
    select id, name from HardwareType order by name;
</sql:query>
<form method="get" action="admin/addHardwareRelationshipType.jsp">
    <input type="hidden" name="referringPage" value="${thisPage}">
    <table>
        <tr>
            <td>
                <input type="submit" value="Add Hardware Relationship Type"
                   <c:if test="${! mayAdmin}">disabled</c:if>>
            </td>
            <td>
                <div>Name:</div> <input type="text" name="name" required>
            </td>
            <td>
                <div>Hardware Type:</div>
                <select name="hardwareTypeId">
                    <c:forEach var="htRow" items="${hardwareTypesQ.rows}">
                        <option value="${htRow.id}">${htRow.name}</option>
                    </c:forEach>
                </select>
            </td>
            <td>
                <div>Component Type:</div>
                <select name="minorTypeId">
                    <c:forEach var="htRow" items="${hardwareTypesQ.rows}">
                        <option value="${htRow.id}">${htRow.name}</option>
                    </c:forEach>
                </select>
            </td>
        </tr>
        <tr>
            <td>
                <div>If all items must come from the same batch,<br> specify multiple items and a single slot name.<br>
                    Otherwise the number of items and slot names must match.</div>
            </td>
            <td>
                <div>Description:</div> <textarea name="description"></textarea>
            </td>
            <td>
                <div># Items</div>
                <input type="number" name="nItems" value="1">
            </td>
            <td>
                <div>Slot Names<br>(comma separated):</div> <input type="text" name="slotNames">
            </td>
        </tr>
    </table>
</form>
