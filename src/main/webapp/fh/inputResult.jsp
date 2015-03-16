<%-- 
    Document   : inputResult
    Created on : Dec 18, 2013, 4:05:25 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
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
                <traveler:registerFile activityId="${param.activityId}" name="${param.value}" mode="manual" 
                                       varFsPath="fsPath" varDcPath="dcPath" varDcPk="dcPk"/>
                <%-- Upload it 
                
                --%>
            </c:when>                   
            <c:otherwise>
                <c:set var="tableName" value="IntResultManual"/>
            </c:otherwise>
        </c:choose>
        <sql:update>
insert into ${tableName} set
inputPatternId=?<sql:param value="${param.inputPatternId}"/>,
activityId=?<sql:param value="${param.activityId}"/>,
<c:choose>
    <c:when test="${param.ISName == 'filepath'}">
value=?<sql:param value="${fsPath}"/>,
virtualPath=?<sql:param value="${dcPath}"/>,
catalogKey=?<sql:param value="${dcPk}"/>,
    </c:when>
    <c:otherwise>
value=?<sql:param value="${param.value}"/>,
    </c:otherwise>
</c:choose>
createdBy=?<sql:param value="${userName}"/>,
creationTS=UTC_TIMESTAMP();
        </sql:update>

        <c:redirect url="${header.referer}"/>
    </body>
</html>
