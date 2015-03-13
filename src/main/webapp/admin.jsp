<%-- 
    Document   : admin
    Created on : Oct 3, 2013, 2:57:59 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>eTraveler Administration</title>
    </head>
    <body>
<hr> 
        <c:set var="backend" value="/eTravelerBackend"/>
        <c:set var="backendLink" 
        value="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${backend}"/>
        <c:url var="backendUrl" value="${backendLink}"/>
        <a href="${backendUrl}">Upload a new Traveler Type or version</a>
<hr>
        <sql:query var="processesQ">
            select id, name from Process where id not in (select rootProcessId from TravelerType);
        </sql:query>
        <form method="get" action="fh/addTravelerType.jsp">
            <input type="submit" value="Add Traveler Type">
            Root Process: <select name="rootProcessId">
                <c:forEach var="process" items="${processesQ.rows}">
                    <option value="${process.id}"><c:out value="${process.name}"/></option>
                </c:forEach>
            </select>
            Owner: <input type="text" name="owner">
            Reason: <input type="text" name="reason">
        </form>
<hr>
<form method="get" action="fh/addHardwareGroup.jsp">
    <input type="submit" value="Add Hardware Group">
    Name: <input name="name" type="text" required>
    Description: <input name="description" type="text">
</form>
<hr>
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
            
        <sql:query var="hardwareTypesQ" >
            select id, name from HardwareType
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
        </form>

        <traveler:hardwareRelationshipTypeList/>
<hr>
        <form method="get" action="fh/addSite.jsp">
            <input type="submit" value="Add Site">
            Name: <input type="text" name="name" required>
            jhVirtualEnv: <input type="text" name="jhVirtualEnv">
            jhOutputRoot: <input type="text" name="jhOutputRoot">
        </form>
        
        <traveler:siteList/>
<hr>
        
        <sql:query var="sitesQ" >
            select id, name from Site
        </sql:query>
        <form method="get" action="fh/addLocation.jsp">
            <input type="submit" value="Add Location">
            Name: <input type="text" name="name" required>
            Site: <select name="siteId">
                <c:forEach var="siteRow" items="${sitesQ.rows}">
                    <option value="${siteRow.id}" <c:if test="${preferences.siteName==siteRow.name}">selected</c:if>>${siteRow.name}</option>
                </c:forEach>
            </select>
        </form>

        <traveler:locationList/>
<hr>

        <form method="get" action="fh/addHardwareIdentifierAuthority.jsp">
            <input type="submit" value="Add Hardware Identifier Authority">
            Name: <input type="text" name="name" required>
        </form>

        <traveler:hardwareIdentifierAuthorityList/>
<hr>
    </body>
</html>
