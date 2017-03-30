<%-- 
    Document   : createTraveler
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
        <title>Create Traveler</title>
    </head>
    <body>
        <traveler:checkFreshness formToken="${param.freshnessToken}"/>        
        
        <traveler:checkMask var="mayStart" processId="${param.processId}"/>
        <c:if test="${! mayStart}">
            <traveler:error message="You don't have permission to start this traveler."/>
        </c:if>
        <sql:transaction>
            <sql:query var="exceptionTypeQ">
                select ET.id as exceptionTypeId 
                from Process P
                inner join ExceptionType ET on ET.exitProcessId = P.id
                    and ET.returnProcessId = P.id
                    and ET.rootProcessId = P.id
                    and ET.NCRProcessId = P.id
                    and ET.exitProcessPath is null
                    and ET.returnProcessPath is null
                inner join TravelerType TT on TT.rootProcessId = P.id
                where P.id = ?<sql:param value="${param.processId}"/>
                and TT.standaloneNCR != 0
            </sql:query>
            <c:if test="${! empty exceptionTypeQ.rows}">
                <c:set var="exceptionTypeId" value="${exceptionTypeQ.rows[0].exceptionTypeId}"/>
            </c:if>
            <ta:createTraveler var="activityId"
                hardwareId="${param.hardwareId}" 
                processId="${param.processId}"
                jobHarnessId="${param.jobHarnessId}"
                exceptionTypeId="${exceptionTypeId}"/>
        </sql:transaction>
        <traveler:redirDA activityId="${activityId}"/>
    </body>
</html>
