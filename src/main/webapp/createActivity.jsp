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
        <sql:update dataSource="jdbc/rd-lsst-cam">
            insert into Activity set
            hardwareId=?<sql:param value="${param.hardwareId}"/>,
            processId=?<sql:param value="${param.processId}"/>,
            parentActivityId=?<sql:param value="${param.parentActivityId}"/>,
            processEdgeId=?<sql:param value="${param.processEdgeId}"/>,
            inNCR=?<sql:param value="${param.inNCR}"/>,
            createdBy=?<sql:param value="${userName}"/>,
            creationTS=NOW();
        </sql:update>
        <c:redirect url="displayActivity.jsp">
            <c:param name="activityId" value="${param.topActivityId}"/>
        </c:redirect>
    </body>
</html>
