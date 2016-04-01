<%-- 
    Document   : hardwareLabelWidget
    Created on : Mar 22, 2016, 4:30:01 PM
    Author     : focke
--%>

<%@tag description="Display various stuff about a component's labels" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="hardwareId" required="true"%>

<traveler:fullRequestString var="thisPage"/>
<traveler:checkSsPerm var="mayManage" hardwareId="${hardwareId}" roles="subsystemManager"/>

<traveler:getSetLabels var="labelQ" hardwareId="${hardwareId}"/>
<traveler:hardwareStatusTable result="${labelQ}"/>
<form action="operator/setHardwareStatus.jsp">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
    <input type="hidden" name="referringPage" value="${thisPage}">
    <input type="hidden" name="hardwareId" value="${hardwareId}">
    <input type="hidden" name="removeLabel" value="true">
    <select name="hardwareStatusId" required>
        <option value="" selected>Pick a label to remove</option>
        <c:forEach var="sRow" items="${labelQ.rows}">
            <option value="${sRow.statusId}"><c:out value="${sRow.statusName}"/></option>
        </c:forEach>        
    </select>
    Reason: <textarea name="reason" required="true"></textarea>
    <input type="submit" value="Remove Label"
           <c:if test="${! mayManage}">disabled</c:if>>
</form>

<traveler:getUnsetLabels var="unsetQ" hardwareId="${hardwareId}"/>
<form action="operator/setHardwareStatus.jsp">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
    <input type="hidden" name="referringPage" value="${thisPage}">
    <input type="hidden" name="hardwareId" value="${hardwareId}">
    <input type="hidden" name="removeLabel" value="false">
    <select name="hardwareStatusId" required>
        <option value="" selected>Pick a label to add</option>
        <c:forEach var="sRow" items="${unsetQ.rows}">
            <option value="${sRow.id}"><c:out value="${sRow.name}"/></option>
        </c:forEach>        
    </select>
    Reason: <textarea name="reason" required="true"></textarea>
    <input type="submit" value="Add Label"
           <c:if test="${! mayManage}">disabled</c:if>>
</form>