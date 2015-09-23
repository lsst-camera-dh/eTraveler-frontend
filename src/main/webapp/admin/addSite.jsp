<%-- 
    Document   : addSite
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
        <title>Add Site</title>
    </head>
    <body>
<sql:transaction>
        <sql:update >
            insert into Site set
            name=?<sql:param value="${param.name}"/>,
            createdBy=?<sql:param value="${userName}"/>,
            creationTS=UTC_TIMESTAMP();
        </sql:update>
        <sql:query var="siteQ">
            select last_insert_id() as id;
        </sql:query>
</sql:transaction>
        <c:redirect url="/displaySite.jsp" context="/eTraveler">
            <c:param name="siteId" value="${siteQ.rows[0].id}"/>
        </c:redirect>
    </body>
</html>
