<%-- 
    Document   : hardwareStatusForm
    Created on : Jun 27, 2013, 2:28:52 PM
    Author     : focke
--%>

<%@tag description="Provide a form to change the status of a component" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="hardwareId" required="true"%>

<traveler:fullRequestString var="thisPage"/>
<traveler:checkSsPerm var="mayManage" hardwareId="${hardwareId}" roles="subsystemManager"/>

<traveler:getAvailableStates var="statesQ" hardwareId="${hardwareId}"/>
<form action="operator/setHardwareStatus.jsp">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
    <input type="hidden" name="referringPage" value="${thisPage}">
    <input type="hidden" name="hardwareId" value="${hardwareId}">
    <select name="hardwareStatusId" required>
        <option value="" selected>Pick a new status</option>
        <c:forEach var="sRow" items="${statesQ.rows}">
            <option value="${sRow.id}"><c:out value="${sRow.name}"/></option>
        </c:forEach>        
    </select>
    Reason: <textarea name="reason" required="true"></textarea>
    <input type="submit" value="Change Status"
           <c:if test="${! mayManage}">disabled</c:if>>
</form>