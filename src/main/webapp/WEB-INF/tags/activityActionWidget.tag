<%-- 
    Document   : activityActionWidget
    Created on : Oct 18, 2017, 2:35:35 PM
    Author     : focke
--%>

<%@tag description="Showhistory for location, status, labels done in a step" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="activityId" required="true"%>

<sql:query var="locQ">
    select S.name as siteName, L.name as locName
    from Site S
    inner join Location L on L.siteId = S.id
    inner join HardwareLocationHistory HLH on HLH.locationId = L.id
    where HLH.activityId = ?<sql:param value="${activityId}"/>;
</sql:query>

<c:forEach var="row" items="${locQ.rows}">
    <h3>Component was moved to ${row.siteName}:${row.locName}</h3>
</c:forEach>

    
<sql:query var="statusQ">
    select HS.name
    from HardwareStatus HS
    left join HardwareStatusHistory HSH on HSH.hardwareStatusId = HS.id
    where HSH.activityId = ?<sql:param value="${activityId}"/>;
</sql:query>

<c:forEach var="row" items="${statusQ.rows}">
    <h3>Component's status was set to ${row.name}</h3>
</c:forEach>
    

<sql:query var="addQ">
    select L.name as labelName, LG.name as groupName
    from Label L
    inner join LabelGroup LG on LG.id = L.labelGroupId
    inner join LabelHistory LH on LH.labelId = L.id
    where LH.activityId = ?<sql:param value="${activityId}"/>
    and LH.adding = 1;
</sql:query>
    
<c:forEach var="row" items="${addQ.rows}">
    <h3>Label ${row.groupName}:${row.labelName} was added</h3>
</c:forEach>
    

<sql:query var="remQ">
    select L.name as labelName, LG.name as groupName
    from Label L
    inner join LabelGroup LG on LG.id = L.labelGroupId
    inner join LabelHistory LH on LH.labelId = L.id
    where LH.activityId = ?<sql:param value="${activityId}"/>
    and LH.adding = 0;
</sql:query>
    
<c:forEach var="row" items="${remQ.rows}">
    <h3>Label ${row.groupName}:${row.labelName} was removed</h3>
</c:forEach>
