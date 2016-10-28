<%-- 
    Document   : setManufacturerId
    Created on : Oct 28, 2016, 3:08:36 PM
    Author     : focke
--%>

<%@tag description="Set hardware manufacturer serial via API" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

    <sql:query var="mfidQ">
select H.id, H.manufacturerId 
from Hardware H
inner join HardwareType HT on HT.id = H.hardwareTypeId
where H.lsstId = ?<sql:param value="${inputs.experimentSN}"/>
and HT.name = ?<sql:param value="${inputs.hardwareTypeName}"/>;
    </sql:query>

<c:if test="${empty mfidQ.rows}">
    <traveler:error message="No such component"/>
</c:if>
<c:set var="hw" value="${mfidQ.rows[0]}"/>

<c:if test="${! empty hw.manufacturerId}">
    <traveler:error message="Mfr serial is already set"/>
</c:if>

    <sql:update>
update Hardware set manufacturerId = ?<sql:param value="${inputs.manufacturerId}"/> 
where id = ?<sql:param value="${hw.id}"/>;
    </sql:update>

{"acknowledge": null}
