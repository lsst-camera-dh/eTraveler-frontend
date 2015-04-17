<%-- 
    Document   : listTravelers
    Created on : Jan 30, 2013, 3:51:03 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Traveler List 
            <c:if test="${! empty param.processId}">
                <sql:query var="processQ" >
                    select name from Process where id=?<sql:param value="${param.processId}"/>
                </sql:query>
                for type <c:out value="${processQ.rows[0].name}"/>
            </c:if>
        </title>
    </head>
    <body>
        <traveler:activityList travelersOnly="true" processId="${param.processId}" done="${param.done}" hardwareId="${param.hardwareId}"/>
    </body>
</html>
