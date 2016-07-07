<%-- 
    Document   : addSignature
    Created on : Apr 12, 2016, 3:18:54 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
<traveler:checkFreshness formToken="${param.freshnessToken}"/>

<c:if test="${(empty param.sigGroup and empty param.sigRole) or (! empty param.sigGroup and ! empty param.sigRole)}">
        <traveler:error message="You must supply a username or a role, but not both."/>
</c:if>
<c:set var="signerRequest" value="${empty param.sigGroup ? param.sigRole : param.sigGroup}"/>

<sql:transaction>
    <ta:addSignature activityId="${param.activityId}" 
                     inputPatternId="${param.inputPatternId}" 
                     signerRequest="${signerRequest}"/>
</sql:transaction>
<c:redirect url="${param.referringPage}"/>
    </body>
</html>
