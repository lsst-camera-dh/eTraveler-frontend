<%-- 
    Document   : admin
    Created on : Oct 3, 2013, 2:57:59 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>eTraveler Administration</title>
    </head>
    <body>

<hr> 
<h2>Backend</h2>
    <c:set var="backend" value="/eTravelerBackend"/>
    <c:set var="backendLink" 
    value="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${backend}"/>
    <c:url var="backendUrl" value="${backendLink}">
        <c:param name="dataSoucreMode" value="${appVariables.dataSourceMode}"/>
    </c:url>
    <a href="${backendUrl}">Upload a new Traveler Type or version</a>

<hr>
<h2>Traveler Types</h2>
    <traveler:newTravelerTypeForm/>

<hr>
<h2>Hardware Groups</h2>
    <form method="get" action="fh/addHardwareGroup.jsp">
        <input type="submit" value="Add Hardware Group">
        Name: <input name="name" type="text" required>
        Description: <input name="description" type="text">
    </form>

<hr>
<h2>Hardware Types</h2>
    <form method="get" action="fh/addHardwareType.jsp">
        <input type="submit" value="Add Hardware Type">
        Name or Drawing #: <input type="text" name="name" required>
        Sequence width - set to zero if not automatic:<select name="width">
            <option value="0">0</option>
            <option value="1">1</option>
            <option value="2">2</option>
            <option value="3">3</option>
            <option value="4" selected>4</option>
            <option value="5">5</option>
        </select><br>
        Description: <input type="text" name="description">
    </form>

<hr>
<h2>Hardware Relationship Types</h2>
    <sql:query var="hardwareTypesQ" >
        select id, name from HardwareType order by name;
    </sql:query>
    <form method="get" action="fh/addHardwareRelationshipType.jsp">
        <input type="submit" value="Add Hardware Relationship Type">
        Name: <input type="text" name="name" required>
        Hardware Type: <select name="hardwareTypeId">
            <c:forEach var="htRow" items="${hardwareTypesQ.rows}">
                <option value="${htRow.id}">${htRow.name}</option>
            </c:forEach>
        </select>
        Component Type: <select name="componentTypeId">
            <c:forEach var="htRow" items="${hardwareTypesQ.rows}">
                <option value="${htRow.id}">${htRow.name}</option>
            </c:forEach>
        </select>
        Slot: <input type="number" name="slot" value="1">
    </form>
    <traveler:hardwareRelationshipTypeList/>

<hr>
<h2>Sites</h2>
    <form method="get" action="fh/addSite.jsp">
        <input type="submit" value="Add Site">
        Name: <input type="text" name="name" required>
        jhVirtualEnv: <input type="text" name="jhVirtualEnv">
        jhOutputRoot: <input type="text" name="jhOutputRoot">
    </form>

<hr>
<h2>Locations</h2>
    <traveler:newLocationForm/>

<hr>
<h2>Hardware Identifier Authorities</h2>
    <form method="get" action="fh/addHardwareIdentifierAuthority.jsp">
        <input type="submit" value="Add Hardware Identifier Authority">
        Name: <input type="text" name="name" required>
    </form>
    <traveler:hardwareIdentifierAuthorityList/>
<hr>
    </body>
</html>
