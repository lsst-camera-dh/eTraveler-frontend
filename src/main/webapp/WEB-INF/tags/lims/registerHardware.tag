<%-- 
    Document   : limsRegisterHardware
    Created on : Oct 15, 2015, 4:53:12 PM
    Author     : focke
--%>

<%@tag description="Register new Hardware from scripting API" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="lims" tagdir="/WEB-INF/tags/lims"%>

<lims:checkHardwareType var="hardwareTypeId"
    inputTypeId="" inputTypeName="${inputs.htype}"/>

    <sql:query var="locQ">
select L.id 
from Location L
inner join Site S on S.id=L.siteId
where L.name=?<sql:param value="${inputs.location}"/>
and S.name=?<sql:param value="${inputs.site}"/>
;
    </sql:query>
<c:if test="${empty locQ.rows}">
    <traveler:error message="No location with name ${inputs.location} and site ${inputs.site} found."/>
</c:if>

<ta:createHardware var="hardwareId" hardwareTypeId="${hardwareTypeId}" locationId="${locQ.rows[0].id}"
                   manufacturerId="${inputs.manufacturerId}" model="${inputs.model}"
                   manufactureDateStr="${inputs.manufactureDate}" manufacturer="${inputs.manufacturer}"
                   quantity="${inputs.quantity}" lsstId="${inputs.experimentSN}"/>

{"id": ${hardwareId}, "acknowledge": null}
