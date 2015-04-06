<%-- 
    Document   : updateTravelerType
    Created on : Apr 6, 2015, 11:07:53 AM
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
        <title>Update tt${param.travelerTypeId} status ${param.status}</title>
    </head>
    <body>
        
        
        <sql:query var="ttQ">
select id from TravelerType where id=?<sql:param value="${param.travelerTypeId}"/>;
        </sql:query>

        <c:choose>
            <c:when test="${empty ttQ.rows}">
                <traveler:error message="TravelerType ${param.travelerTypeId} does not exist!"/>
            </c:when>
            <c:otherwise>
                <ta:setTravelerTypeStatus travelerTypeId="${param.travelerTypeId}" status="${param.status}"/>
                <c:redirect url="${header.referer}"/> 
            </c:otherwise>
        </c:choose>
    </body>
</html>
