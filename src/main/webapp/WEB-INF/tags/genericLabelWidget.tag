<%-- 
    Document   : genericLabelWidget
    Created on : Nov 14, 2016, 4:07 PM
    Author     : jrb
--%>

<%@tag description="Display various stuff about an objects's labels" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="objectId" required="true"%>
<%@attribute name="objectTypeName" required="true"%>

<traveler:fullRequestString var="thisPage"/>    <%-- What's this about? --%>

<sql:query var="objectTypeQ">
    select id from Labelable where name=?<sql:param value="${objectTypeName}"/>;
</sql:query>
<c:set var="objectTypeId" value="${objectTypeQ.rows[0].id}" />

<sql:query var="subsysIdQ">
   call generic_subsystem(?, ?)
   <sql:param value="${objectId}"/>
   <sql:param value="${objectTypeId}"/>
   
</sql:query>
<c:set var="subsysId" value="${subsysIdQ.rows[0].subsystemId}" />
 <%-- <c:out value="Subsystem is ${subsysId}" /> <br /> --%>

<traveler:checkSsPerm var="mayManage" subsystemId="${subsysId}" roles="subsystemManager"/>

<sql:query var="hardwareGroupsQ">
   call generic_hardwareGroups(?, ?)
   <sql:param value="${objectId}"/>
   <sql:param value="${objectTypeId}"/>
</sql:query>

<traveler:getSetGenericLabels var="genLabelQ" objectId="${objectId}" objectTypeId="${objectTypeId}"/>
<traveler:genericLabelTable result="${genLabelQ}"/>
<form action="operator/modifyLabels.jsp">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
    <input type="hidden" name="referringPage" value="${thisPage}">
    <input type="hidden" name="objectId" value="${objectId}">
    <input type="hidden" name="objectTypeId" value="${objectTypeId}">
    <input type="hidden" name="removeLabel" value="true">
    <select name="labelId" required>
        <option value="" selected>Pick a label to remove</option>
        <c:forEach var="sRow" items="${genLabelQ.rows}">
            <option value="${sRow.theLabelId}">
	    <c:out value="${sRow.labelGroupName}:${sRow.labelName}"/>
	    <%-- </option>  --%>
        </c:forEach>        
    </select>
    Reason: <textarea name="reason" required="true"></textarea>
    <input type="submit" value="Remove Label"
        <c:if test="${! mayManage}">disabled</c:if>>  
</form>

<traveler:getUnsetGenericLabels var="genUnsetQ" objectId="${objectId}"
objectTypeId="${objectTypeId}" subsysId="${subsysId}"
hgResult="${hardwareGroupsQ}"/>
<form action="operator/modifyLabels.jsp">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
    <input type="hidden" name="referringPage" value="${thisPage}">
    <input type="hidden" name="objectId" value="${objectId}">
    <input type="hidden" name="objectTypeId" value="${objectTypeId}">
    <input type="hidden" name="removeLabel" value="false">
    <select name="labelId" required>
        <option value="" selected>Pick a label to add</option>
        <c:forEach var="sRow" items="${genUnsetQ.rows}">
            <option value="${sRow.id}"><c:out value="${sRow.labelGroupName}:${sRow.name}"/></option>
        </c:forEach>        
    </select>
    Reason: <textarea name="reason" required="true"></textarea>
    <input type="submit" value="Add Label"
        <c:if test="${! mayManage}">disabled</c:if>>
</form>
