<%-- 
    Document   : createHardware
    Created on : Jan 30, 2013, 2:22:04 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Create Hardware</title>
    </head>
    <body>
        <traveler:checkFreshness formToken="${param.freshnessToken}"/>        
        
        <traveler:checkSsPerm var="mayOperate" hardwareTypeId="${param.hardwareTypeId}" roles="operator,supervisor"/>
        <c:if test="${! mayOperate}">
            <sql:query var="hardwareTypeQ">
select HT.name as hardwareTypeName, SS.name as subsystemName
from HardwareType HT
inner join Subsystem SS on SS.id=HT.subsystemId
where HT.id=<sql:param value="${param.hardwareTypeId}"/>
;
            </sql:query>
            <c:set var="hardwareType" value="${hardwareTypeQ.rows[0]}"/>
            <traveler:error message="Registration of components of type ${hardwareType.hardwareTypeName} requires membership in subsystem ${hardwareType.subsystemName}"/>
        </c:if>

        <sql:transaction >
            <ta:createHardware hardwareTypeId="${param.hardwareTypeId}" lsstId="${param.lsstId}"
                               quantity="${param.quantity}" manufacturer="${param.manufacturer}"
                               manufacturerId="${param.manufacturerId}" model="${param.model}"
                               manufactureDateStr="${param.manufactureDateDate}" locationId="${param.locationId}"
                               var="hardwareId"/>
        </sql:transaction>
        <c:redirect url="/displayHardware.jsp" context="/eTraveler">
            <c:param name="hardwareId" value="${hardwareId}"/>
        </c:redirect>
    </body>
</html>
