<%-- 
    Document   : createActivity
    Created on : Jan 30, 2013, 2:22:04 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Create Activity</title>
    </head>
    <body>
        <c:set var="allOk" value="true"/>
        <c:set var="message" value="Tell the developers you ran into bug #282805"/>
        
        <c:choose>
            <c:when test="${allOk}">
<sql:transaction>
                <ta:createActivity hardwareId="${param.hardwareId}" processId="${param.processId}"
                    parentActivityId="${param.parentActivityId}" processEdgeId="${param.processEdgeId}"
                    inNCR="${param.inNCR}" var="newActivityId"/>
</sql:transaction>

                <traveler:redirDA/>
            </c:when>
            <c:otherwise>
                <c:out value="${message}"/>
            </c:otherwise>
        </c:choose>
    </body>
</html>
