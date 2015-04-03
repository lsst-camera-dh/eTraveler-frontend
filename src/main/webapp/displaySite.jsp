<%-- 
    Document   : displaySite
    Created on : Apr 2, 2015, 9:00:19 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<sql:query var="siteQ">
    select * from Site where id=?<sql:param value="${param.siteId}"/>;
</sql:query>
<c:set var="site" value="${siteQ.rows[0]}"/>
    
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Site <c:out value="${site.name}"/></title>
    </head>
    <body>
        <h3>Site Info</h3>
        Name: <c:out value="${site.name}"/><br>
        Job Harness Install: <c:out value="${site.jhVirtualEnv}"/><br>
        Job Harness Output: <c:out value="${site.jhOutputRoot}"/><br>
        Creator: <c:out value="${site.createdBy}"/><br>
        Date: <c:out value="${site.creationTS}"/><br>
        
        <h3>Locations</h3>
        <traveler:newLocationForm siteId="${param.siteId}"/>
        <traveler:locationList siteId="${param.siteId}"/>
        
        <h3>Components</h3>
        <traveler:hardwareList siteId="${param.siteId}"/>
    </body>
</html>
