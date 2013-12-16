<%-- 
    Document   : setLocation
    Created on : Sep 30, 2013, 2:53:04 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="newLocationId" required="true"%>
<%@attribute name="hardwareId" required="true"%>

<sql:update >
    insert into HardwareLocationHistory set
    locationId=?<sql:param value="${newLocationId}"/>,
    hardwareId=?<sql:param value="${hardwareId}"/>,
    createdBy=?<sql:param value="${userName}"/>,
    creationTS=now();
</sql:update>

<sql:query var="childrenQ" >
    select * from HardwareRelationship
    where hardwareId=?<sql:param value="${hardwareId}"/>
    and end is null;
</sql:query>
<c:forEach var="childRow" items="${childrenQ.rows}">
    <traveler:setHardwareLocation newLocationId="${newLocationId}" hardwareId="${childRow.componentId}"/>
</c:forEach>