<%-- 
    Document   : closeoutActivity
    Created on : Jan 30, 2013, 8:14:38 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Closeout Activity</title>
    </head>
    <body>

        <sql:transaction >
            <ta:closeoutActivity activityId="${param.activityId}" newLocationId="${param.newLocationId}"/>

            <sql:query var="activityQ">
select * from Activity where id=?<sql:param value="${param.activityId}"/>;
            </sql:query>
            <c:set var="activity" value="${activityQ.rows[0]}"/>
        </sql:transaction>
        
        <c:if test="${activity.inNCR && empty activity.parentActivityId}">
            <c:url var="ncrUrl" value="finishNCR.jsp">
                <c:param name="activityId" value="${param.activityId}"/>
            </c:url>
            <c:redirect url="${ncrUrl}"/>
        </c:if>
                    
        <traveler:redirDA/>
    </body>
</html>
