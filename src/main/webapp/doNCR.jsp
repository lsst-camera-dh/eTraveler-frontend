<%-- 
    Document   : doNCR
    Created on : Jun 23, 2014, 10:52:57 AM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Do NCR</title>
    </head>
    <body>
        <sql:query var="hardwareQ">
select hardwareId from Activity where id=?<sql:param value="${param.activityId}"/>
        </sql:query>
        <sql:query var="travelerQ">
select NCRProcessId from ExceptionType where id=?<sql:param value="${param.exceptionTypeId}"/>
        </sql:query>
        <sql:update>
update StopWorkHistory set
    resolutionTS=utc_timestamp(),
    resolvedBy=?<sql:param value="${userName}"/>,
    resolution='QUIT'
where 
    activityId=?<sql:param value="${param.activityId}"/>
    and
    resolutionTS is null;
        </sql:update>
        <ta:createTraveler var="NCRActivityId"
            hardwareId="${hardwareQ.rows[0].hardwareId}" 
            processId="${travelerQ.rows[0].NCRProcessId}"
            inNCR="true"/>
        <sql:update>
<%-- This should be in a transaction. but createTraveler already uses one :-( --%>
insert into Exception set
exceptionTypeId=?<sql:param value="${param.exceptionTypeId}"/>,
exitActivityId=?<sql:param value="${param.activityId}"/>,
NCRActivityId=?<sql:param value="${NCRActivityId}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=UTC_TIMESTAMP();
        </sql:update>
        <traveler:redirDA activityId="${NCRActivityId}"/>        
    </body>
</html>
