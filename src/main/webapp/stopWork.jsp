<%-- 
    Document   : stopWork
    Created on : May 9, 2014, 3:22:29 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Stop Work</title>
    </head>
    <body>
        <h1>Stopping Work for Activity ${param.activityId}</h1>
        <sql:query var="groupsQ">
            select * from PermissionGroup order by maskBit desc
        </sql:query>
        <form method="get" action="fh/stopTraveler.jsp">
            <input type="hidden" name="activityId" value="${param.activityId}">       
            <input type="hidden" name="topActivityId" value="${param.topActivityId}">
            <table>
                <tr><td>Why?</td><td><textarea name="reason"></textarea></td>
<%--                <tr><td>Who can restart?</td>
                    <td>
            <c:forEach var="group" items="${groupsQ.rows}">
                <input type="checkbox" name="group" value="${group.maskBit}">${group.name}
            </c:forEach>
                    </td></tr>--%>
                </table>
            <input type="submit" value="Yes, really stop">
        </form>
    </body>
</html>
