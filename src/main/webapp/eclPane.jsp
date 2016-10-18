<%-- 
    Document   : eclWidget
    Created on : Oct 18, 2016, 2:28:26 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>ECL pane</title>
    </head>
    <body>
        <c:catch var="ex">
            <traveler:eclImpl author="${param.author}" hardwareTypeId="${param.hardwareTypeId}" 
                          hardwareGroupId="${param.hardwareGroupId}" hardwareId="${param.hardwareId}" 
                          processId="${param.processId}" activityId="${param.activityId}"/>
        </c:catch>
        <c:if test="${! empty ex}">
            <h2>eLog not available</h2>
        </c:if>
    </body>
</html>
