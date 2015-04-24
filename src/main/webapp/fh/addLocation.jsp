<%-- 
    Document   : addLocation
    Created on : Oct 3, 2013, 3:19:15 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Location</title>
    </head>
    <body>
<sql:transaction>  
        <sql:update >
            insert into Location set
            name=?<sql:param value="${param.name}"/>,
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
