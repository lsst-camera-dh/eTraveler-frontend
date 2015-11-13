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
<c:set var="htype" value="${htQ.rows[0]}"/>

<%-- deal with lsstId=auto --%>

    <sql:query var="locQ">
select id 
from Location L
inner join Site S on S.id=L.siteId
where L.name=?<sql:param value="${inputs.location}"/>
and S.name=?<sql:param value="${inputs.site}"/>
;
    </sql:query>

<ta:createHardware var="hardwareId" hardwareTypeId="${hType.id}" locationId="${locQ.rows[0].id}"/>