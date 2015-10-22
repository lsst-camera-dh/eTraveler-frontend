<%-- 
    Document   : admin
    Created on : Oct 3, 2013, 2:57:59 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<traveler:fullRequestString var="thisPage"/>
<traveler:checkPerm var="mayAdmin" groups="EtravelerAdmin"/>

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
        <c:param name="dataSourceMode" value="${appVariables.dataSourceMode}"/>
    </c:url>
    <a href="${backendUrl}">Upload a new Traveler Type or version</a>

<hr>
<h2>Traveler Types</h2>
    <traveler:newTravelerTypeForm/>

<hr>
<h2>Hardware Groups</h2>
    <form method="get" action="admin/addHardwareGroup.jsp">
        <input type="submit" value="Add Hardware Group"
           <c:if test="${! mayAdmin}">disabled</c:if>>
        Name: <input name="name" type="text" required>
        Description: <input name="description" type="text">
    </form>

<hr>
<h2>Hardware Types</h2>
    <form method="get" action="admin/addHardwareType.jsp">
        <input type="submit" value="Add Hardware Type"
           <c:if test="${! mayAdmin}">disabled</c:if>>
        Name or Drawing #:&nbsp;<input type="text" name="name" required>
        Sequence width - set to zero if not automatic:&nbsp;<select name="width">
            <option value="0">0</option>
            <option value="1">1</option>
            <option value="2">2</option>
            <option value="3">3</option>
            <option value="4" selected>4</option>
            <option value="5">5</option>
        </select><br>
        Description:&nbsp;<input type="text" name="description">
        Batched?&nbsp;<input type="radio" name="isBatched" value="0" checked>No&nbsp;<input type="radio" name="isBatched" value="1">Yes<br>
    </form>

<hr>
<h2>Hardware Relationship Types</h2>
<traveler:newRelationshipTypeForm/>
<traveler:hardwareRelationshipTypeList/>

<hr>
<h2>Sites</h2>
    <form method="get" action="admin/addSite.jsp">
        <input type="submit" value="Add Site"
           <c:if test="${! mayAdmin}">disabled</c:if>>
        Name: <input type="text" name="name" required>
        jhVirtualEnv: <input type="text" name="jhVirtualEnv">
        jhOutputRoot: <input type="text" name="jhOutputRoot">
    </form>

<hr>
<h2>Locations</h2>
    <traveler:newLocationForm/>

<hr>
<h2>Hardware Identifier Authorities</h2>
    <form method="get" action="admin/addHardwareIdentifierAuthority.jsp">
        <input type="hidden" name="referringPage" value="${thisPage}">
        <input type="submit" value="Add Hardware Identifier Authority"
           <c:if test="${! mayAdmin}">disabled</c:if>>
        Name: <input type="text" name="name" required>
    </form>
    <traveler:hardwareIdentifierAuthorityList/>
<hr>
    </body>
</html>
