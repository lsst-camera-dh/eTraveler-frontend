<%-- 
    Document   : displayHardwareType
    Created on : May 3, 2013, 1:23:47 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<traveler:checkId table="HardwareType" id="${param.hardwareTypeId}"/>
        
<sql:query var="hardwareTypeQ" >
    select * from HardwareType where id=?<sql:param value="${param.hardwareTypeId}"/>;
</sql:query>
<c:set var="hardwareType" value="${hardwareTypeQ.rows[0]}"/>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Component Type <c:out value="${hardwareType.name}"/></title>
    </head>
    <body>
        <h1>Component type <c:out value="${hardwareType.name}"/></h1>
        Added by <c:out value="${hardwareType.createdBy}"/><br>
        At <c:out value="${hardwareType.creationTS}"/></h2>

        <h2>Applicable Traveler Types</h2>
        <traveler:travelerTypeList hardwareTypeId="${param.hardwareTypeId}"/>
        <traveler:newTravelerForm hardwareTypeId="${param.hardwareTypeId}"/>
   
        <traveler:eclWidget
            author="${userName}"
            hardwareTypeId="${param.hardwareTypeId}"
            />

        <h2>Instances</h2>
        <traveler:hardwareList  hardwareTypeId="${param.hardwareTypeId}"/>
        <h3>Register a new one:</h3>
        <traveler:newHardwareForm hardwareTypeId="${param.hardwareTypeId}"/>
    </body>   
</html>
