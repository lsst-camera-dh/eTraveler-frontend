<%-- 
    Document   : setHardwareStatus
    Created on : Jun 27, 2013, 2:44:09 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Set Hardware Status</title>
    </head>
    <body>
        <traveler:checkFreshness formToken="${param.freshnessToken}"/>        
        
        <c:if test="${empty param.hardwareId}">
            <traveler:error message="You must specifiy which component to operate on."/>
        </c:if>
        
        <c:if test="${empty param.hardwareStatusId}">
            <traveler:error message="You must specifiy a new component status."/>
        </c:if>
        
        <sql:query var="statusQ">
select HSH.hardwareStatusId 
from HardwareStatusHistory HSH
inner join HardwareStatus HS on HS.id=HSH.hardwareStatusId
where HSH.hardwareId=?<sql:param value="${param.hardwareId}"/>
and HS.isStatusValue=1
order by HSH.id desc limit 1;
        </sql:query>
        <c:if test="${statusQ.rows[0].hardwareStatusId == param.hardwareStatusId}">
            <traveler:error message="You can't set the status to the same thing it already is."/>
        </c:if>
        
        <sql:transaction>
            <ta:setHardwareStatus hardwareStatusId="${param.hardwareStatusId}" 
                                  hardwareId="${param.hardwareId}" 
                                  reason="${param.reason}"/>
        </sql:transaction>
        <c:redirect url="${param.referringPage}"/>
</body>
</html>
