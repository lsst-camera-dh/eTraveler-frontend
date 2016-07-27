<%-- 
    Document   : setHardwareLocation
    Created on : Mar 25, 2016, 4:45:14 PM
    Author     : focke
--%>

<%@tag description="change hardware location via API" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="lims" tagdir="/WEB-INF/tags/lims"%>

<lims:checkHardwareType var="htId" inputTypeName="${inputs.hardwareTypeName}" inputTypeId="${inputs.hardwareTypeId}"/>

<traveler:findComponent var="hardwareId" serial="${inputs.experimentSN}" typeName="${inputs.hardwareTypeName}"/>

<c:choose>
    <c:when test="${empty inputs.siteName}">
        <sql:query var="siteQ">
select siteId 
from Location 
where id = (select locationId 
            from HardwareLocationHistory 
            where hardwareId = ?<sql:param value="${hardwareId}"/>
            order by id desc limit 1);
        </sql:query>
    </c:when>
    <c:otherwise>
        <sql:query var="siteQ">
select id as siteId from Site where name = ?<sql:param value="${inputs.siteName}"/>;
        </sql:query>
        <c:if test="${empty siteQ.rows}">
            <traveler:error message="No Site named ${inputs.siteName}"/>
        </c:if>
    </c:otherwise>
</c:choose>
<c:set var="siteId" value="${siteQ.rows[0].siteId}"/>

    <sql:query var="locationQ">
select id 
from Location 
where siteId = ?<sql:param value="${siteId}"/> 
and name = ?<sql:param value="${inputs.locationName}"/>;
    </sql:query>
<c:if test="${empty locationQ.rows}">
    <traveler:error message="No location named ${inputs.locationName} at site ${siteId}"/>
</c:if>
<c:set var="locationId" value="${locationQ.rows[0].id}"/>

<c:set var="reason" value="${empty inputs.reason ? 'Set via API' : inputs.reason}"/>

<ta:setHardwareLocation activityId="${inputs.activityId}" hardwareId="${hardwareId}" 
                        newLocationId="${locationId}" reason="${reason}"/>

{ "acknowledge": null }