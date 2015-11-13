<%-- 
    Document   : limsRegisterHardware
    Created on : Oct 15, 2015, 4:53:12 PM
    Author     : focke
--%>

<%@tag description="Register new hardware from scripting API" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

    <sql:query var="htQ">
select * from HardwareType HT where name=?<sql:param value="${inputs.hardwareType}"/>;
    </sql:query>
<c:set var="hType" value="${htQ.rows[0]}"/>

<c:choose>
    <c:when test="${inputs.experimentSN == 'auto'}">
        <c:choose>
            <c:when test="${hType.autoSequenceWidth==0}">
                <traveler:error message="Experiment serial number set to 'auto' for a non-auto component type."/>
            </c:when>
            <c:otherwise>
                <c:set var="lsstId" value=""/>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <c:set var="lsstId" value="${inputs.experimentSN}"/>
    </c:otherwise>
</c:choose>

    <sql:query var="locQ">
select L.id 
from Location L
inner join Site S on S.id=L.siteId
where L.name=?<sql:param value="${inputs.location}"/>
and S.name=?<sql:param value="${inputs.site}"/>
;
    </sql:query>

<c:set var="userName" value="API" scope=""/>

<ta:createHardware var="hardwareId" hardwareTypeId="${hType.id}" locationId="${locQ.rows[0].id}"
                   manufacturerId="${inputs.manufacturerId}" model="${inputs.model}"
                   manufactureDateStr="${inputs.manufactureDate}" manufacturer="${inputs.manufacturer}"
                   quantity="${inputs.quantity}" lsstId="${lsstId}"/>

{"hardwareId": ${hardwareId}, "acknowledge": null}
