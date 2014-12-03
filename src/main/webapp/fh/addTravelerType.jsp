<%-- 
    Document   : addTravelerType
    Created on : Dec 3, 2014, 2:56:08 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Traveler Type</title>
    </head>
    <body>
        
        <sql:query var="processQ">
select id from Process where id=?<sql:param value="${param.rootProcessId}"/>;
        </sql:query>
        
<c:choose>
    <c:when test="${empty processQ.rows}">
Error: Process <c:out value="${param.rootProcessId}"/> does not exist!
    </c:when>
    <c:otherwise>
        <sql:update>
insert into TravelerType set
    rootProcessId=?<sql:param value="${param.rootProcessId}"/>,
    state='NEW',
    owner=?<sql:param value="${param.owner}"/>,
    reason=?<sql:param value="${param.reason}"/>,
    createdBy=?<sql:param value="${userName}"/>,
    creationTS=now();
        </sql:update>
        <c:redirect url="${header.referer}"/>
    </c:otherwise>
</c:choose>

    </body>
</html>
