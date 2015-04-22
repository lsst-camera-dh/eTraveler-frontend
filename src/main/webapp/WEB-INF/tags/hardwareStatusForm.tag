<%-- 
    Document   : hardwareStatusForm
    Created on : Jun 27, 2013, 2:28:52 PM
    Author     : focke
--%>

<%@tag description="Provide a form to change the status of a component" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="hardwareId" required="true"%>

<sql:query var="statesQ" >
    select * 
    from HardwareStatus 
    where name!='NEW'
    and id!=(select hardwareStatusId from HardwareStatusHistory where hardwareId=?<sql:param value="${hardwareId}"/> order by id desc limit 1);
</sql:query>

<form action="fh/setHardwareStatus.jsp">
    <input type="hidden" name="hardwareId" value="${hardwareId}">
    <select name="hardwareStatusId" required>
        <option value="" selected>Pick a new status</option>
        <c:forEach var="sRow" items="${statesQ.rows}">
            <option value="${sRow.id}"><c:out value="${sRow.name}"/></option>
        </c:forEach>        
    </select>
    <input type="submit" value="Change Status">
</form>