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
    select LG.id as labelGroupId, LG.name as labelGroupName, LG.description as labelGroupDescription,
    LA.name as typeName, 
    SS.id as subsystemId, SS.name as subsystemName, 
    HG.id as hardwareGroupId, HG.name as hardwareGroupName
    from LabelGroup LG
    inner join Labelable LA on LA.id = LG.labelableId
    inner join Subsystem SS on SS.id = LG.subsystemId
    left join HardwareGroup HG on HG.id = LG.hardwareGroupId
    where LG.id = ?<sql:param value="${param.labelGroupId}"/>
</sql:query>
<c:set var="labelGroup" value="${labelGroupQ.rows[0]}"/>

<c:set var="title" value="Label Group ${labelGroup.typeName}:${labelGroup.labelGroupName}"/>

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
            <tr><td>Labelable Objects:</td><td>${labelGroup.typeName}</td></tr>
            <c:url var="ssLink" value="displaySubsystem.jsp">
                <c:param name="subsystemId" value="${labelGroup.subsystemId}"/>
            </c:url>
            <tr><td>Subsystem:</td><td><a href="${ssLink}">${labelGroup.subsystemName}</a></td></tr>
            <c:if test="${! empty labelGroup.hardwareGroupId}">
                <c:url var="hgLink" value="displayHardwareGroup.jsp">
                    <c:param name="hardwareGroupId" value="${labelGroup.hardwareGroupId}"/>
                </c:url>
                <tr><td>Hardware Group:</td><td><a href="${hgLink}">${labelGroup.hardwareGroupName}</a></td></tr>
            </c:if>
        </table>

        <h2>Labels in this group</h2>
        <traveler:labelList labelGroupId="${param.labelGroupId}"/>
        <traveler:newLabelForm labelGroupId="${param.labelGroupId}"/>
        
        <traveler:getSetGenericLabels var="genLabelQ" labelGroupId="${param.labelGroupId}"/>
        <c:if test="${! empty genLabelQ.rows}">
            <h2>${labelGroup.typeName}s with these labels</h2>
            <traveler:genericLabelTable result="${genLabelQ}"/>
        </c:if>
    </body>
</html>
