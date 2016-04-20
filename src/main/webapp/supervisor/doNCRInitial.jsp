<%-- 
    Document   : doNCRInitial
    Created on : Apr 19, 2016, 2:49:53 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
<traveler:checkFreshness formToken="${param.freshnessToken}"/>

<sql:transaction>
    <ta:stopTraveler activityId="${param.activityId}" mask="15" reason="NCR"/>
    <ta:getNCRExceptionType var="exceptionTypeId" activityId="${param.activityId}"/>
</sql:transaction>

<c:url var="doNCR" value="doNCR.jsp">
    <c:param name="freshnessToken" value="${freshnessToken}"/>
    <c:param name="activityId" value="${param.activityId}"/>
    <c:param name="exceptionTypeId" value="${exceptionTypeId}"/>
</c:url>
<c:redirect url="${doNCR}"/>
    </body>
</html>
