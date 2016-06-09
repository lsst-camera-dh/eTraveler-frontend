<%-- 
    Document   : displayHardwareType
    Created on : May 3, 2013, 1:23:47 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<traveler:checkId table="HardwareType" id="${param.hardwareTypeId}"/>
        
    <sql:query var="hardwareTypeQ" >
select H.*, SS.name as subsystemName
from HardwareType H
inner join Subsystem SS on SS.id=H.subsystemId
where H.id=?<sql:param value="${param.hardwareTypeId}"/>;
    </sql:query>
<c:set var="hardwareType" value="${hardwareTypeQ.rows[0]}"/>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Component Type <c:out value="${hardwareType.name}"/></title>
    </head>
    <body>
        <h1>Component type <c:out value="${hardwareType.name}"/></h1>
        Description: <c:out value="${hardwareType.description}"/><br>
        <c:url var="subsysUrl" value="displaySubsystem.jsp">
            <c:param name="subsystemId" value="${hardwareType.subsystemId}"/>
        </c:url>
        Subsystem: <a href="${subsysUrl}">${hardwareType.subsystemName}</a><br>
        Added by <c:out value="${hardwareType.createdBy}"/><br>
        At <c:out value="${hardwareType.creationTS}"/><br>
    
    <h2>Member of Hardware Groups</h2>
    <traveler:hardwareGroupList hardwareTypeId="${param.hardwareTypeId}"/>

        <h2>Components</h2>
        <traveler:hardwareList  hardwareTypeId="${param.hardwareTypeId}"/>
        <h3>Register a new one:</h3>
        <traveler:newHardwareForm hardwareTypeId="${param.hardwareTypeId}"/>

        <h2>Applicable Traveler Types</h2>
        <traveler:travelerTypeList hardwareTypeId="${param.hardwareTypeId}"/>
        <traveler:newTravelerForm hardwareTypeId="${param.hardwareTypeId}"/>
   
        <h2>Relations</h2>
        <h3>Component of</h3>
        <traveler:hardwareRelationshipTypeList componentTypeId="${param.hardwareTypeId}"/>
        <h3>Components</h3>
        <traveler:hardwareRelationshipTypeList assemblyTypeId="${param.hardwareTypeId}"/>
        
        <traveler:eclWidget
            author="${userName}"
            hardwareTypeId="${param.hardwareTypeId}"
            />

    </body>   
</html>
