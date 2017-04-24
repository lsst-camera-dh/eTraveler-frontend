<%-- 
    Document   : inputResult
    Created on : Dec 18, 2013, 4:05:25 PM
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
        <title>Input Result</title>
    </head>
    <body>
<traveler:checkFreshness formToken="${param.freshnessToken}"/>

<sql:transaction>
    <c:forEach var="pattern" begin="0" end="${param.nInputs - 1}" step="1">
        <c:set var="valueName" value="value${pattern}"/>
        <c:if test="${! empty param[valueName]}">
            <c:set var="inputName" value="inputPatternId${pattern}"/>
            <ta:inputResult inputPatternId="${param[inputName]}" 
                            value="${param[valueName]}" 
                            activityId="${param.activityId}"
                            fieldName="${valueName}"/>
        </c:if>
    </c:forEach>
</sql:transaction>
<c:redirect url="${param.referringPage}"/>
    </body>
</html>
