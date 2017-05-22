<%-- 
    Document   : displayLabelGroup
    Created on : May 18, 2017, 12:33:40 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<sql:query var="labelGroupQ">
    select LG.id as labelGroupId, LG.name as labelGroupName, LG.description as labelGroupDescription
    from LabelGroup LG
    where LG.id = ?<sql:param value="${param.labelGroupId}"/>
</sql:query>
<c:set var="labelGroup" value="${labelGroupQ.rows[0]}"/>

<c:set var="title" value="Label Group ${labelGroup.labelGroupName}"/>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${title}</title>
    </head>
    <body>
        <h1>${title}</h1>
        
        <table>
            <tr><td>Label Group:</td><td>${labelGroup.labelGroupName}</td></tr>
            <tr><td>Description:</td><td>${labelGroup.labelGroupDescription}</td></tr>
        </table>

        <traveler:labelList labelGroupId="${param.labelGroupId}"/>
        <traveler:newLabelForm labelGroupId="${param.labelGroupId}"/>
    </body>
</html>
