<%-- 
    Document   : displayActivity
    Created on : Jan 29, 2013, 5:09:56 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Activity</title>
    </head>
    <body>
        <traveler:setPaths activityId="${param.activityId}"/>
        
        <sql:query var="activityQ" dataSource="jdbc/rd-lsst-cam">
            select * from Activity where id=?<sql:param value="${param.activityId}"/>;
        </sql:query>
        <c:set var="activity" value="${activityQ.rows[0]}"/>
            
        <h1>Activity
            <c:out value="${activityPath}"/>
            <traveler:activityCrumbs activityPath="${activityPath}"/>
        </h1>
        <display:table name="${activityQ.rows}" class="datatable"/>

        <h2>Process
            <c:out value="${processPath}"/>
            <traveler:processCrumbs processPath="${processPath}"/>
        </h2>
        <sql:query var="processQ" dataSource="jdbc/rd-lsst-cam">
            select * from Process where id=?<sql:param value="${activity.processId}"/>;
        </sql:query>
        <display:table name="${processQ.rows}" class="datatable"/>
        
        <traveler:hardwareHeader hardwareId="${activity.hardwareId}"/>
        
        <h2>Steps</h2>
        <traveler:activityTable activityId="${param.activityId}"/>
            
    </body>
</html>
