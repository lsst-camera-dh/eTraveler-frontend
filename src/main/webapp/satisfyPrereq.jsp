<%-- 
    Document   : satusfyPrereq
    Created on : Aug 1, 2013, 3:14:57 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <sql:update dataSource="jdbc/rd-lsst-cam">
            insert into Prerequisite set
            prerequisitePatternId=?<sql:param value="${param.prerequisitePatternId}"/>,
            activityId=?<sql:param value="${param.activityId}"/>,
            <c:if test="${! empty param.prerequisiteActivityId}">
                prerequisiteActivityId=?<sql:param value="${param.prerequisiteActivityId}"/>,
            </c:if>
            <c:if test="${! empty param.hardwareId}">
                hardwareId=?<sql:param value="${param.hardwareId}"/>,
            </c:if>
            createdBy=?<sql:param value="${userName}"/>,
            creationTs=now();
        </sql:update>
                
        <c:redirect url="${header.referer}"/>
    </body>
</html>
