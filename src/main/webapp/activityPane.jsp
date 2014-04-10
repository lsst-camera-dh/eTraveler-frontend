<%-- 
    Document   : processPane
    Created on : May 21, 2013, 12:42:51 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Activity <c:out value="${param.activityId}"/></title>
    </head>
    <body>
        <sql:query var="activityQ" >
            select 
            A.processId, A.hardwareId,
            concat(P.name, ' v', P.version) as processName, P.hardwareTypeId
            from Activity A
            inner join Process P on P.id=A.processId
            where A.id=?<sql:param value="${param.activityId}"/>;
        </sql:query>
        <c:set var="activity" value="${activityQ.rows[0]}"/>
          
        <h2><c:out value="${activity.processName}"/></h2>
        <traveler:processWidget processId="${activity.processId}"/>
        <traveler:activityWidget activityId="${param.activityId}"/>
        <traveler:eclWidget
            author="${userName}"
            hardwareTypeId="${activity.hardwareTypeId}"
            hardwareId="${activity.hardwareId}"
            processId="${activity.processId}"
            activityId="${param.activityId}"
            />
    </body>
</html>
