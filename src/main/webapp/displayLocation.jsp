<%-- 
    Document   : displayLocation
    Created on : Apr 2, 2015, 9:00:19 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<sql:query var="locationQ">
    select L.*, S.id as siteId, S.name as siteName
    from Location L
    inner join Site S on S.id=L.siteId
    where L.id=?<sql:param value="${param.locationId}"/>;
</sql:query>
<c:set var="location" value="${locationQ.rows[0]}"/>

<c:url var="siteLink" value="displaySite.jsp">
    <c:param name="siteId" value="${location.siteId}"/>
</c:url>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Location <c:out value="${location.siteName}"/> <c:out value="${location.name}"/></title>
    </head>
    <body>
        <h3>Location Info</h3>
<table>
    <tr> <td>Name:</td> <td><c:out value="${location.name}"/></td> </tr>
    <tr> <td>Site:</td> <td><a href="${siteLink}">${location.siteName}</a></td> </tr>
    <tr> <td>Creator:</td> <td><c:out value="${location.createdBy}"/></td> </tr>
    <tr> <td>Date:</td> <td><c:out value="${location.creationTS}"/></td> </tr>
</table>

        <h3>Components</h3>
        <traveler:hardwareList locationId="${param.locationId}"/>
    </body>
</html>
