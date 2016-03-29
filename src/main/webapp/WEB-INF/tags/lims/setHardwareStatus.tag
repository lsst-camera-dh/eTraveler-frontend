<%-- 
    Document   : setHardwareStatus
    Created on : Mar 25, 2016, 4:45:14 PM
    Author     : focke
--%>

<%@tag description="change hardware status (or set/unset label) via API" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="lims" tagdir="/WEB-INF/tags/lims"%>

<lims:checkHardwareType var="htId" inputTypeName="${inputs.hardwareTypeName}" inputTypeId="${inputs.hardwareTypeId}"/>

<sql:query var="hardwareQ">
select id 
from Hardware
where lsstId=?<sql:param value="${inputs.experimentSN}"/>
and hardwareTypeId=?<sql:param value="${htId}"/>
;
</sql:query>
<c:choose>
    <c:when test="${empty hardwareQ.rows}">
        <traveler:error message="No component with serial '${inputs.experimentSN}' and type '${inputs.hardwareTypeName}' found"/>
    </c:when>
    <c:otherwise>
        <c:set var="hardwareId" value="${hardwareQ.rows[0].id}"/>
    </c:otherwise>
</c:choose>

<c:set var="reason" value="${empty inputs.reason ? 'Set via API' : inputs.reason}"/>

<c:set var="removeLabel" value="${! inputs.adding}"/>

<ta:setHardwareStatus activityId="${inputs.activityId}" hardwareId="${hardwareId}" 
                      hardwareStatusName="${inputs.hardwareStatusName}" reason="${reason}" 
                      removeLabel="${removeLabel}"/>

{ "acknowledge": null }