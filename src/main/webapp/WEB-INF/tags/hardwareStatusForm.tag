<%-- 
    Document   : hardwareStatusForm
    Created on : Jun 27, 2013, 2:28:52 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="hardwareId" required="true"%>

<sql:query var="statesQ" dataSource="jdbc/rd-lsst-cam">
    select * from HardwareStatus
</sql:query>

<form action="setHardwareStatus.jsp">
    <input type="hidden" name="hardwareId" value="${hardwareId}">
    <select name="hardwareStatusId">
        <c:forEach var="sRow" items="${statesQ.rows}">
            <option value="${sRow.id}"><c:out value="${sRow.name}"/></option>
        </c:forEach>        
    </select>
    <input type="submit" value="Change Status">
</form>