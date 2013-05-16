<%-- 
    Document   : createTraveler
    Created on : Jan 30, 2013, 2:22:04 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Create Hardware</title>
    </head>
    <body>
        <sql:transaction dataSource="jdbc/rd-lsst-cam">
            <sql:update>
                insert into Hardware set
                lsstId=?<sql:param value="${param.lsstId}"/>,
                typeId=?<sql:param value="${param.typeId}"/>,
                createdBy=?<sql:param value="${userName}"/>,
                creationTS=NOW();
            </sql:update>
            <sql:query var="hardwareQ">
                select * from Hardware where id=LAST_INSERT_ID();
            </sql:query>
            <c:set var="hardware" value="${hardwareQ.rows[0]}"/>
        </sql:transaction>
        <c:redirect url="displayHardware.jsp">
            <c:param name="hardwareId" value="${hardware.id}"/>
        </c:redirect>
    </body>
</html>
