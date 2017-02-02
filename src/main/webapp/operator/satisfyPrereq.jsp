<%-- 
    Document   : satisfyPrereq
    Created on : Aug 1, 2013, 3:14:57 PM
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
        <title>Satisfy prerequisite</title>
    </head>
    <body>
        <traveler:checkFreshness formToken="${param.freshnessToken}"/>        
        
        <sql:transaction >
            <c:forEach var="pattern" begin="0" end="${param.nPrereqs - 1}" step="1">
                <c:set var="valueName" value="value${pattern}"/>
                <c:if test="${! empty param[valueName]}">
                    <c:set var="patternName" value="prerequisitePatternId${pattern}"/>
                    <ta:satisfyPrereq prerequisitePatternId="${param[patternName]}"
                                      activityId="${param.activityId}"
                                      prerequisiteActivityId="${param.prerequisiteActivityId}"
                                      hardwareId="${param.componentId}"/>
                </c:if>
            </c:forEach>
        </sql:transaction>
                
        <c:redirect url="${param.referringPage}"/>
    </body>
</html>
