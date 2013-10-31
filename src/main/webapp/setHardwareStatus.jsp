<%-- 
    Document   : setHardwareStatus
    Created on : Jun 27, 2013, 2:44:09 PM
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
        <sql:transaction dataSource="jdbc/rd-lsst-cam">
            <sql:update>
                update Hardware set 
                hardwareStatusId=?<sql:param value="${param.hardwareStatusId}"/>
                where
                id=?<sql:param value="${param.hardwareId}"/>;
            </sql:update>
            <sql:update>
                insert into HardwareStatusHistory set
                hardwareStatusId=?<sql:param value="${param.hardwareStatusId}"/>,
                hardwareId=?<sql:param value="${param.hardwareId}"/>,
                createdBy=?<sql:param value="${userName}"/>,
                creationTS=now();
            </sql:update>
        </sql:transaction>
        <c:redirect url="${header.referer}"/>
    </body>
</html>
