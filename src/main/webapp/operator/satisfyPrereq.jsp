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
            <ta:satisfyPrereq prerequisitePatternId="${param.prerequisitePatternId}"
                              activityId="${param.activityId}"
                              prerequisiteActivityId="${param.prerequisiteActivityId}"
                              hardwareId="${param.componentId}"/>
        </sql:transaction>
                
        <c:redirect url="${param.referringPage}"/>
    </body>
</html>
