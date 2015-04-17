<%-- 
    Document   : travelerTypeStatusForm
    Created on : Apr 6, 2015, 11:10:09 AM
    Author     : focke
--%>

<%@tag description="A form to change the status of a TravelerType" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="travelerTypeId" required="true"%>

<sql:query var="oldStateQ">
    select TTS.name
    from TravelerTypeState TTS
        inner join TravelerTypeStateHistory TTSH on TTSH.travelerTypeStateId=TTS.id
    where TTSH.travelerTypeId=?<sql:param value="${travelerTypeId}"/>
    order by TTSH.id desc limit 1;
</sql:query>

<sql:query var="newStatesQ">
    select id, name from TravelerTypeState where name not in ('new', ?<sql:param value="${oldStateQ.rows[0].name}"/>);
</sql:query>

<form action="fh/updateTravelerType.jsp" method="get">
    <input type="submit" value="Update Traveler Type Status">
    <input type="hidden" name="travelerTypeId" value="${travelerTypeId}">
    State:
    <select name="stateId">
        <c:forEach var="newState" items="${newStatesQ.rows}">
            <option value="${newState.id}"><c:out value="${newState.name}"/></option>
        </c:forEach>
    </select>
    Reason:<input type='text' name='reason'>
</form>