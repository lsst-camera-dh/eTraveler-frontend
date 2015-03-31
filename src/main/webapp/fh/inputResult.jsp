<%-- 
    Document   : inputResult
    Created on : Dec 18, 2013, 4:05:25 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Input Result</title>
    </head>
    <body>
        <c:choose>
            <c:when test="${param.isName == 'float'}">
                <c:set var="tableName" value="FloatResultManual"/>
            </c:when>
            <c:when test="${param.isName == 'string'}">
                <c:set var="tableName" value="StringResultManual"/>
            </c:when>
            <c:when test="${param.isName == 'filepath'}">
                <c:set var="tableName" value="FilepathResultManual"/>

                <ta:registerFile activityId="${param.activityId}" fileItem="${fileItems.value}" mode="manual" 
                                 varFsPath="fsPath" varDcPath="dcPath" varDcPk="dcPk"/>
                <%-- File is saved in registerFile.
                Which also sets uploadedFileSize and uploadDigest at request scope
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
    <c:when test="${param.isName == 'filepath'}">
value=?<sql:param value="${fsPath}"/>,
virtualPath=?<sql:param value="${dcPath}"/>,
catalogKey=?<sql:param value="${dcPk}"/>,
size=?<sql:param value="${uploadedFileSize}"/>,
sha1=?<sql:param value="${uploadDigest}"/>,
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
