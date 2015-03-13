<%-- 
    Document   : inputResult
    Created on : Dec 18, 2013, 4:05:25 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Input Result</title>
    </head>
    <body>
        <c:choose>
            <c:when test="${param.ISName == 'float'}">
                <c:set var="tableName" value="FloatResultManual"/>
            </c:when>
            <c:when test="${param.ISName == 'string'}">
                <c:set var="tableName" value="StringResultManual"/>
            </c:when>
            <c:when test="${param.ISName == 'filepath'}">
                <c:set var="tableName" value="FilepathResultManual"/>
            </c:when>                   
            <c:otherwise>
                <c:set var="tableName" value="IntResultManual"/>
            </c:otherwise>
        </c:choose>
        <sql:update>
            insert into ${tableName} set
            inputPatternId=?<sql:param value="${param.inputPatternId}"/>,
            <%--name=(select label from InputPattern where id=?<sql:param value="${param.inputPatternId}"/>),--%>
            value=?<sql:param value="${param.value}"/>,
            activityId=?<sql:param value="${param.activityId}"/>,
            createdBy=?<sql:param value="${userName}"/>,
            creationTS=UTC_TIMESTAMP();
        </sql:update>

        <c:redirect url="${header.referer}"/>
    </body>
</html>
