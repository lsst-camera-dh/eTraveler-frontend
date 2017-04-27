<%-- 
    Document   : addLocation
    Created on : Oct 3, 2013, 3:19:15 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Location</title>
    </head>
    <body>
<traveler:checkFreshness formToken="${param.freshnessToken}"/>

<c:choose>
    <c:when test="${! empty param.parentId}">
        <sql:query var="parentQ">
select name, siteId from Location where id = ?<sql:param value="${param.parentId}"/>
        </sql:query>
        <c:if test="${parentQ.rows[0].siteId != param.siteId}">
            <traveler:error message="Site and parent location don't match"/>
        </c:if>
        <c:set var="locName" value="${parentQ.rows[0].name}/${param.name}"/>
    </c:when>
    <c:otherwise>
        <c:set var="locName" value="${param.name}"/>
    </c:otherwise>
</c:choose>

<sql:transaction>  
        <sql:update >
            insert into Location set
            name=?<sql:param value="${locName}"/>,
            siteId=?<sql:param value="${param.siteId}"/>,
            createdBy=?<sql:param value="${userName}"/>,
            creationTS=UTC_TIMESTAMP();
        </sql:update>
        <sql:query var="idQ">
            select last_insert_id() as id;
        </sql:query>
</sql:transaction>
        <c:redirect url="/displayLocation.jsp" context="/eTraveler">
            <c:param name="locationId" value="${idQ.rows[0].id}"/>
        </c:redirect>
    </body>
</html>
