<%-- 
    Document   : createTraveler
    Created on : Jan 30, 2013, 2:22:04 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Create Traveler</title>
    </head>
    <body>
        <sql:transaction dataSource="jdbc/rd-lsst-cam">
            <sql:update>
                insert into Activity set
                hardwareId=?<sql:param value="${param.hardwareId}"/>,
                processId=?<sql:param value="${param.processId}"/>,
                inNCR=?<sql:param value="${param.inNCR}"/>,
                createdBy=?<sql:param value="${userName}"/>,
                creationTS=NOW();
            </sql:update>
            <sql:query var="activityQ">
                select * from Activity where id=LAST_INSERT_ID()                
            </sql:query>
        </sql:transaction>
        <c:set var="activity" value="${activityQ.rows[0]}"/>
        <c:redirect url="displayActivity.jsp">
            <c:param name="activityId" value="${activity.id}"/>
        </c:redirect>
    </body>
</html>
