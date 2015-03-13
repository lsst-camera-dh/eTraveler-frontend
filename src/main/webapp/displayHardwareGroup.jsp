<%-- 
    Document   : displayHardwareGroup
    Created on : Mar 12, 2015, 3:32:43 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>

<sql:query var="hardwareGroupQ">
    select * from HardwareGroup where id=?<sql:param value="${param.hardwareGroupId}"/>;
</sql:query>
<c:set var="hardwareGroup" value="${hardwareGroupQ.rows[0]}"/>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hardware Group <c:out value="${hardwareGroup.name}"/></title>
    </head>
    <body>
        <h1>Hardware Group <c:out value="${hardwareGroup.name}"/></h1>
        <h2>Descrription</h2>
            <c:out value="${hardwareGroup.description}"/>
        <h2>Member Hardware Types</h2>
            <traveler:hardwareTypeList hardwareGroupId="${param.hardwareGroupId}"/>
        <h2>Applicable Traveler Types</h2>
            <traveler:travelerTypeList hardwareGroupId="${param.hardwareGroupId}"/>
        <h2>Start a Traveler:</h2>
            <traveler:newTravelerForm hardwareGroupId="${param.hardwareGroupId}"/>
    </body>
</html>
