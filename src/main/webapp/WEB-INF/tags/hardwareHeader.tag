<%-- 
    Document   : hardwareHeader
    Created on : Apr 22, 2013, 1:04:50 PM
    Author     : focke
--%>

<%@tag description="Displays a little info about a component" pageEncoding="US-ASCII"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="hardwareId" required="true"%>

<sql:query var="hardwareQ" >
    select H.*, HT.name, HT.id as hardwareTypeId, HS.name as hardwareStatusName from Hardware H, HardwareType HT, HardwareStatus HS
    where 
    HT.id=H.hardwareTypeId
    and
    HS.id=H.hardwareStatusId
    and
    H.id=?<sql:param value="${hardwareId}"/>;
</sql:query>
<c:set var="hardware" value="${hardwareQ.rows[0]}"/>
<c:set var="hardwareTypeId" value="${hardware.hardwareTypeId}" scope="request"/>

<c:url var="hwtLink" value="displayHardwareType.jsp">
    <c:param name="hardwareTypeId" value="${hardwareTypeId}"/>
</c:url>
<c:url var="hwLink" value="displayHardware.jsp">
    <c:param name="hardwareId" value="${hardware.id}"/>
</c:url>
<%--
<a href="${hwtLink}"><c:out value="${hardware.name}"/></a> Id <a href="<c:out value="${hwLink}"/>"><c:out value="${hardware.lsstId}"/></a>
<br>
Registered at <c:out value="${hardware.creationTS}"/> by <c:out value="${hardware.createdBy}"/>
--%>
<table>
    <tr><td>Type:</td><td><a href="${hwtLink}"><c:out value="${hardware.name}"/></a></td></tr>
    <tr><td>LSST Serial Number:</td><td><a href="<c:out value="${hwLink}"/>"><c:out value="${hardware.lsstId}"/></a></td></tr>
    <tr><td>Manufacturer:</td><td><c:out value="${hardware.manufacturer}"/></td></tr>
    <tr><td>Model:</td><td><c:out value="${hardware.model}"/></td></tr>
    <tr><td>Date:</td><td><c:out value="${hardware.manufactureDate}"/></td></tr>
    <tr><td>Status:</td><td><c:out value="${hardware.hardwareStatusName}"/></td></tr>
    <tr><td>Registered by:</td><td><c:out value="${hardware.createdBy}"/></td></tr>
    <tr><td>Registered at:</td><td><c:out value="${hardware.creationTS}"/></td></tr>
</table>

