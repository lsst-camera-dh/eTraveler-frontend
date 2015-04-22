<%-- 
    Document   : displayHardwareGroup
    Created on : Mar 12, 2015, 3:32:43 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
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
        Creator: <c:out value="${hardwareGroup.createdBy}"/><br>
        Date: <c:out value="${hardwareGroup.creationTS}"/><br>
        <h2>Description</h2>
            <c:out value="${hardwareGroup.description}"/>
        <h2>Member Hardware Types</h2>
        <sql:query var="hwTypesQ">
            select id, name 
            from HardwareType 
            where id not in (select hardwareTypeId 
                             from HardwareTypeGroupMapping 
                             where hardwareGroupId=?<sql:param value="${param.hardwareGroupId}"/>)
            ;
        </sql:query>
            <form method="get" action="fh/addTypeToGroup.jsp">
                <input type="submit" value="Add Member Type">
                <input type="hidden" name="hardwareGroupId" value="${param.hardwareGroupId}">
                <select name="hardwareTypeId">
                    <c:forEach var="hwType" items="${hwTypesQ.rows}">
                        <option value="${hwType.id}"><c:out value="${hwType.name}"/></option>
                    </c:forEach>
                </select>
            </form>
            <traveler:hardwareTypeList hardwareGroupId="${param.hardwareGroupId}"/>
        <h2>Applicable Traveler Types</h2>
            <traveler:travelerTypeList hardwareGroupId="${param.hardwareGroupId}"/>
        <h2>Start a Traveler:</h2>
            <traveler:newTravelerForm hardwareGroupId="${param.hardwareGroupId}"/>
        <h2>Components</h2>
        <traveler:hardwareList hardwareGroupId="${param.hardwareGroupId}"/>
    </body>
</html>
