<%-- 
    Document   : initiateTraveller
    Created on : Jan 30, 2013, 2:15:51 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Initiate Traveler</title>
    </head>
    <body>
        <sql:query var="typeQ" >
            select * from HardwareType
            where id=?<sql:param value="${param.hardwareTypeId}"/>;
        </sql:query>
        <c:set var="hType" value="${typeQ.rows[0]}"/>

       
        <h1>
        Initiating traveler for component type
        <c:out value="${hType.name}"/>
        </h1>
            
        <traveler:newTravelerForm hardwareTypeId="${param.hardwareTypeId}"/>
    </body>
</html>
