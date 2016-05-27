<%-- 
    Document   : getPendingBatch
    Created on : May 26, 2016, 4:39:42 PM
    Author     : focke
--%>

<%@tag description="find or create pending batch corresponding to a normal one" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="hardwareId" required="true"%>
<%@attribute name="activityId"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="pendingId" scope="AT_BEGIN"%>

    <sql:query var="hardwareQ">
select H.*, HLH.locationId
from Hardware H 
left join HardwareLocationHistory HLH on HLH.hardwareId = H.id
where H.id = ?<sql:param value="${hardwareId}"/>
order by HLH.id desc limit 1
;
    </sql:query>
<c:set var="hardware" value="hardwareQ.rows[0]"/>

<c:set var="pendingName" value="${hardware.lsstId}-Pending"/>

    <sql:query var="pendingQ">
select id from Hardware 
where lsstId = ?<sql:param value="${pendingName}"/> 
and hardwareTypeId = ?<sql:param value="${hardware.hardwareTypeId}"/>;
    </sql:query>
<c:choose>
    <c:when test="${! empty pendingQ.rows}">
        <c:set var="pendingId" value="${pendingQ.rows[0].id}"/>
    </c:when>
    <c:otherwise>
        <ta:createHardware var="pendingId"
                           hardwareTypeId="${hardware.hardwareTypeId}"
                           lsstId="${pendingName}"
                           quantity="0"
                           manufacturer="${hardware.manufacturer}"
                           manufacturerId="${hardware.manufacturerId}"
                           model="${hardware.model}"
                           manufactureDateStr="${hardware.manufactureDate}"
                           locationId="${hardware.locationId}"/>
        <ta:setHardwareStatus hardwareId="${pendingId}"
                              hardwareStatusName="PENDING"
                              activityId="${activityId}"
                              reason="Items removed from batch ${hardware.lsstId}"/>
    </c:otherwise>
</c:choose>