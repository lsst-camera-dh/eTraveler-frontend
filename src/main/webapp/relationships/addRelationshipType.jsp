<%-- 
    Document   : addRelationshipType
    Created on : Oct 3, 2013, 3:19:15 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="relationships" tagdir="/WEB-INF/tags/relationships"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add MultiRelationshipType</title>
    </head>
    <body>
        <traveler:checkSpaces var="theName" input="${param.name}" fieldName="Name"/>
        <traveler:checkFreshness formToken="${param.freshnessToken}"/>

        <traveler:checkSsPerm var="mayAdmin" hardwareTypeId="${param.hardwareTypeId}" roles="admin"/>
        <c:if test="${! mayAdmin}">
            <sql:query var="subsysQ">
select SS.name
from HardwareType HT
inner join Subsystem SS on SS.id=HT.subsystemId
where HT.id=?<sql:param value="${param.hardwareTypeId}"/>
;
            </sql:query>
            <traveler:error message="This operation requires admin prviledge in subsystem ${subsysQ.rows[0].name}"/>
        </c:if>
        
        <sql:transaction>
            <relationships:createRelationshipType slotNames="${param.slotNames}" minorTypeId="${param.minorTypeId}"
                numItems="${param.numItems}" name="${theName}" hardwareTypeId="${param.hardwareTypeId}"
                description="${param.description}" var="mrtId"/>
        </sql:transaction>
        <c:redirect url="${param.referringPage}"/>
    </body>
</html>
