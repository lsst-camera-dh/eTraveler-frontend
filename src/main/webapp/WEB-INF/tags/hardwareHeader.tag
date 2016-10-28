<%-- 
    Document   : hardwareHeader
    Created on : Apr 22, 2013, 1:04:50 PM
    Author     : focke
--%>

<%@tag description="Displays a little info about a component" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="hardwareId" required="true"%>

<sql:query var="hardwareQ" >
    select 
    H.*, 
    HT.name, HT.id as hardwareTypeId, HT.description,
    HS.name as hardwareStatusName
    from 
    Hardware H
    inner join HardwareType HT on HT.id=H.hardwareTypeId
    inner join HardwareStatusHistory HSH on HSH.hardwareId=H.id and HSH.id=(select max(HSH2.id) from HardwareStatusHistory HSH2 inner join HardwareStatus HS on HS.id=HSH2.hardwareStatusId where HSH2.hardwareId=H.id and HS.isStatusValue=1)
    inner join HardwareStatus HS on HS.id=HSH.hardwareStatusId
    where
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

<table>
    <tr><td>Type:</td><td><a href="${hwtLink}"><c:out value="${hardware.name}"/></a></td></tr>
    <tr><td>Description:</td><td><c:out value="${hardware.description}"/></td></tr>
    <tr><td>${appVariables.experiment} Serial Number:</td><td><a href="<c:out value="${hwLink}"/>"><c:out value="${hardware.lsstId}"/></a></td></tr>
    <tr><td>Manufacturer:</td><td><c:out value="${hardware.manufacturer}"/></td></tr>
    <tr><td>Manufacturer Serial Number:</td><td><a href="<c:out value="${hwLink}"/>"><c:out value="${hardware.manufacturerId}"/></a></td></tr>
    <tr><td>Model:</td><td><c:out value="${hardware.model}"/></td></tr>
    <tr><td>Date:</td><td><c:out value="${hardware.manufactureDate}"/></td></tr>
    <tr><td>Status:</td><td><c:out value="${hardware.hardwareStatusName}"/></td></tr>
    <tr><td>Registered by:</td><td><c:out value="${hardware.createdBy}"/></td></tr>
    <tr><td>Registered at:</td><td><c:out value="${hardware.creationTS}"/></td></tr>
</table>
