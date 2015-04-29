<%-- 
    Document   : setLocation
    Created on : Sep 30, 2013, 2:53:04 PM
    Author     : focke
--%>

<%@tag description="Change the Location of a component" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="newLocationId" required="true"%>
<%@attribute name="hardwareId" required="true"%>
<%@attribute name="activityId"%>

<sql:update >
    insert into HardwareLocationHistory set
    locationId=?<sql:param value="${newLocationId}"/>,
    hardwareId=?<sql:param value="${hardwareId}"/>,
    <c:if test="${! empty activityId}">
        activityId=?<sql:param value="${activityId}"/>,
    </c:if>
    createdBy=?<sql:param value="${userName}"/>,
    creationTS=UTC_TIMESTAMP();
</sql:update>

<sql:query var="childrenQ" >
    select * from HardwareRelationship
    where hardwareId=?<sql:param value="${hardwareId}"/>
    and end is null;
</sql:query>
<c:forEach var="childRow" items="${childrenQ.rows}">
    <ta:setHardwareLocation newLocationId="${newLocationId}" hardwareId="${childRow.componentId}" activityId="${activityId}"/>
</c:forEach>