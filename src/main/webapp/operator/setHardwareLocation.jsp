<%-- 
    Document   : setLocation
    Created on : Sep 24, 2013, 4:48:45 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Set Hardware Location</title>
    </head>
    <body>
<traveler:checkFreshness formToken="${param.freshnessToken}"/>        
        
<c:if test="${empty param.newLocationId}">
    <traveler:error message="Go back and select a location."/>
</c:if>

<sql:query var="locQ">
    select locationId 
    from HardwareLocationHistory 
    where hardwareId=?<sql:param value="${param.hardwareId}"/>
    order by creationTS desc limit 1;
</sql:query>
<c:if test="${! empty locQ.rows}">
    <c:if test="${param.newLocationId == locQ.rows[0].locationId}">
        <traveler:error message="You can't move component to where it already is."/>
    </c:if>
</c:if>

<sql:query var="parentsQ" >
select MRS.hardwareId, MRS.minorId, MRA.name
from MultiRelationshipSlot MRS
inner join MultiRelationshipHistory MRH on MRH.multirelationshipSlotId=MRS.id
        and MRH.id=(select max(id) from MultiRelationshipHistory where multirelationshipSlotId=MRS.id)
inner join MultiRelationshipAction MRA on MRA.id=MRH.multirelationshipActionId
where MRS.minorId=?<sql:param value="${param.hardwareId}"/>
and MRA.name='install';
</sql:query>
<c:if test="${! empty parentsQ.rows}">
    <c:url value="displayHardware.jsp" var="parentLink">
        <c:param name="hardwareId" value="${parentsQ.rows[0].hardwareId}"/>
    </c:url>
    <traveler:error message="Sorry, this item cannot be moved because it is part of <a href='${parentLink}'>this</a>."/>
</c:if>

<sql:transaction>
    <ta:setHardwareLocation hardwareId="${param.hardwareId}" newLocationId="${param.newLocationId}" reason="${param.reason}"/>
</sql:transaction>

<c:redirect url="${param.referringPage}"/>
    </body>
</html>
