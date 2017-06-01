<%-- 
    Document   : displayLabel
    Created on : May 18, 2017, 12:33:40 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<sql:query var="labelQ">
    select L.name as labelName, L.description as labelDescription,
    LG.id as labelGroupId, LG.name as labelGroupName, LG.description as labelGroupDescription,
    LA.name as typeName
    from Label L
    inner join LabelGroup LG on LG.id = L.labelGroupId
    inner join Labelable LA on LA.id = LG.labelableId
    where L.id = ?<sql:param value="${param.labelId}"/>
</sql:query>
<c:set var="label" value="${labelQ.rows[0]}"/>

<c:set var="title" value="Label ${label.typeName}:${label.labelGroupName}:${label.labelName}"/>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${title}</title>
    </head>
    <body>
        <h1>${title}</h1>
        
        <c:url var="labelGroupLink" value="displayLabelGroup.jsp">
            <c:param name="labelGroupId" value="${label.labelGroupId}"/>
        </c:url>
        
        <table>
            <tr><td>Label:</td><td>${label.labelName}</td></tr>
            <tr><td>Description:</td><td>${label.labelDescription}</td></tr>
            <tr><td>Label Group:</td><td><a href="${labelGroupLink}">${label.labelGroupName}</a></td></tr>
            <tr><td>Group Description:</td><td>${label.labelGroupDescription}</td></tr>
        </table>
        
        <traveler:getSetGenericLabels var="genLabelQ" labelId="${param.labelId}"/>
        <c:if test="${! empty genLabelQ.rows}">
            <h2>Applied Labels</h2>
            <traveler:genericLabelTable result="${genLabelQ}"/>
        </c:if>

            <h2>Generic Labels</h2>
	<traveler:genericLabelWidget objectId="${param.labelId}"
                                     objectTypeName="label" />        
    </body>
</html>
