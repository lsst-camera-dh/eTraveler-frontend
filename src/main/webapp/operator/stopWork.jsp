<%-- 
    Document   : stopWork
    Created on : May 9, 2014, 3:22:29 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<traveler:checkPerm var="mayOperate" groups="EtravelerOperator,EtravelerSupervisor"/>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Stop Work</title>
    </head>
    <body>
        <h1>Stopping Work for Activity ${param.activityId}</h1>
        <form method="get" action="stopTraveler.jsp">
            <input type="hidden" name="activityId" value="${param.activityId}">       
            <input type="hidden" name="topActivityId" value="${param.topActivityId}">
            <table>
                <tr><td>Why?</td><td><textarea name="reason" required="true"></textarea></td>
            </table>
            <input type="submit" value="Yes, really stop"
                <c:if test="${! mayOperate}">disabled</c:if>>
        </form>
    </body>
</html>
