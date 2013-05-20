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

<sql:query var="hardwareQ" dataSource="jdbc/rd-lsst-cam">
    select H.*, HT.name, HT.id as hardwareTypeId from Hardware H, HardwareType HT
    where 
    HT.id=H.typeId
    and
    H.id=?<sql:param value="${hardwareId}"/>;
</sql:query>
<c:set var="hardware" value="${hardwareQ.rows[0]}"/>

<c:url var="hwtLink" value="displayHardwareType.jsp">
    <c:param name="hardwareTypeId" value="${hardware.hardwareTypeId}"/>
</c:url>
<c:url var="hwLink" value="displayHardware.jsp">
    <c:param name="hardwareId" value="${hardware.id}"/>
</c:url>
<a href="${hwtLink}"><c:out value="${hardware.name}"/></a> Id <a href="<c:out value="${hwLink}"/>"><c:out value="${hardware.lsstId}"/></a>
<br>
Registered at <c:out value="${hardware.creationTS}"/> by <c:out value="${hardware.createdBy}"/>

<c:set var="hardwareTypeId" value="${hardware.typeId}" scope="request"/>
