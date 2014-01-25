<%-- 
    Document   : newTravelerForm.tag
    Created on : Jan 24, 2014, 2:51:15 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%@attribute name="processId" required="true"%>

<sql:query var="hardwareQ" >
    select H.id, H.lsstId
    from 
    Process P
    inner join Hardware H on H.hardwareTypeId=P.hardwareTypeId
    where 
    P.id=?<sql:param value="${processId}"/>;
</sql:query>

<form METHOD=GET ACTION="createTraveler.jsp">
    <input type="hidden" name="processId" value="${processId}"/>
    <input type="hidden" name="inNCR" value="FALSE">

    Component: 
    <select name="hardwareId">
        <c:forEach var="hRow" items="${hardwareQ.rows}">
            <option value="${hRow.id}">${hRow.lsstId}</option>
        </c:forEach>
    </select>
    <INPUT TYPE=SUBMIT value="Begin Process">
</form>
