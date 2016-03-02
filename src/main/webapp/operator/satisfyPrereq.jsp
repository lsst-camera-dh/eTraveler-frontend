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
            <sql:update>
                insert into Prerequisite set
                prerequisitePatternId=?<sql:param value="${param.prerequisitePatternId}"/>,
                activityId=?<sql:param value="${param.activityId}"/>,
                <c:if test="${! empty param.prerequisiteActivityId}">
                    prerequisiteActivityId=?<sql:param value="${param.prerequisiteActivityId}"/>,
                </c:if>
                <c:if test="${! empty param.componentId}">
                    hardwareId=?<sql:param value="${param.componentId}"/>,
                </c:if>
                createdBy=?<sql:param value="${userName}"/>,
                creationTs=UTC_TIMESTAMP();
            </sql:update>
        </sql:transaction>
                
        <c:redirect url="${param.referringPage}"/>
    </body>
</html>
