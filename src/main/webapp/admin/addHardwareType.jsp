<%-- 
    Document   : addHardwareType
    Created on : Oct 3, 2013, 3:19:15 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add HardwareType</title>
    </head>
    <body>
        <traveler:checkSsPerm var="mayAdmin" subsystemId="${param.subsystemId}" roles="admin"/>
        <c:if test="${! mayAdmin}">
            <sql:query var="subsysQ">
select name from Subsystem where id=?<sql:param value="${param.subsystemId}"/>;
            </sql:query>
            <traveler:error message="This operation requires admin priviledge for subsystem ${subsysQ.rows[0].name}."/>
        </c:if>
        
        <sql:transaction>
            <ta:createHardwareType var="hardwareTypeId" name="${param.name}"
                                   width="${param.width}" isBatched="${param.isBatched}"
                                   description="${param.description}" subsystemId="${param.subsystemId}"/>
        </sql:transaction>
        <c:redirect url="/displayHardwareType.jsp" context="/eTraveler">
            <c:param name="hardwareTypeId" value="${hardwareTypeId}"/>
        </c:redirect>
    </body>
</html>
