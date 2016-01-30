<%-- 
    Document   : addTypeToGroup
    Created on : Mar 13, 2015, 1:29:04 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add HardwareType to HardwareGroup</title>
    </head>
    <body>
<traveler:checkSsPerm var="mayAdmin" hardwareTypeId="${param.hardwareTypeId}" roles="admin"/>
<c:if test="${! mayAdmin}">
    <sql:query var="htQ">
select HT.name as hardwareTypeName, SS.name as subsystemName
from HardwareType HT
inner join Subsystem SS on SS.id=HT.subsystemId
where HT.id=?<sql:param value="${param.hardwareTypeId}"/>
;
    </sql:query>
    <c:set var="ht" value="${htQ.rows[0]}"/>
    <traveler:error message="Adding hardware type ${ht.hardwareTypeName} to a group requires admin priviledge in subsystem ${ht.subsystemName}"/>
</c:if>
<sql:transaction>        
        <sql:update>
            insert into HardwareTypeGroupMapping set
            hardwareGroupId=?<sql:param value="${param.hardwareGroupId}"/>,
            hardwareTypeId=?<sql:param value="${param.hardwareTypeId}"/>,
            createdBy=?<sql:param value="${userName}"/>,
            creationTS=UTC_TIMESTAMP();
        </sql:update>
</sql:transaction>
        <c:redirect url="${param.referringPage}"/>
    </body>
</html>
