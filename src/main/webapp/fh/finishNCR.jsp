<%-- 
    Document   : finishNCR
    Created on : Jul 23, 2014, 3:10:46 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Closeout NCR Activity</title>
    </head>
    <body>

        <sql:query var="exceptionQ">
            select *, E.id as exceptionId from 
            Exception E
            inner join ExceptionType ET on ET.id=E.exceptionTypeId
            where E.NCRActivityId=?<sql:param value="${param.activityId}"/>;
        </sql:query>

        <c:choose>
            <c:when test="${fn:length(exceptionQ.rows) != 1}">
                Inconceivable! #253795
            </c:when>
            <c:otherwise>
                <%--
                <c:set var="exception" value="${exceptionQ.rows[0]}"/>
                <traveler:findTraveler var="returnTravelerId" activityId="${param.activityId}"/>
                <traveler:expandActivity var="stepList" activityId="${returnTravelerId}"/>
                <traveler:finishNCR stepList="${stepList}" returnEdgePath="${exception.returnEdgePath}"
                                    ncrActivityId="${param.activityId}"/>
                --%>
                Uhm, sorry.
            </c:otherwise>
        </c:choose>

    </body>
</html>
