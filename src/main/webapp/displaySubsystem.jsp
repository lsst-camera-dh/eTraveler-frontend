<%-- 
    Document   : displaySubsystem
    Created on : Jan 8, 2016, 11:44:44 AM
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
        <sql:query var="subsysQ">
select * from Subsystem where id=?<sql:param value="${param.subsystemId}"/>;
        </sql:query>
<c:if test="${empty subsysQ.rows}">
    <traveler:error message="No subsystem with id ${param.subsystemId}"/>
</c:if>
<c:set var="subsystem" value="${subsysQ.rows[0]}"/>
        
        <title>Subsystem ${subsystem.name}</title>
    </head>
    <body>
        <h1>Subsystem ${subsystem.name}</h1>
        <h2>Components</h2>
        <traveler:hardwareList  subsystemId="${param.subsystemId}"/>
    </body>
</html>
