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
        <sql:transaction >
            <sql:update>
                insert into Hardware set
                lsstId=?<sql:param value="${param.lsstId}"/>,
                hardwareTypeId=?<sql:param value="${param.hardwareTypeId}"/>,
                manufacturer=?<sql:param value="${param.manufacturer}"/>,
                model=?<sql:param value="${param.model}"/>,
                manufactureDate=?<sql:dateParam value="${param.manufactureDate}"/>,
                hardwareStatusId=(select id from HardwareStatus where name="NEW"),
                createdBy=?<sql:param value="${userName}"/>,
                creationTS=NOW();
            </sql:update>
            <sql:query var="hardwareQ">
                select id from Hardware where id=LAST_INSERT_ID();
            </sql:query>
            <sql:update>
                insert into HardwareStatusHistory set
                hardwareStatusId=(select id from HardwareStatus where name="NEW"),
                hardwareId=LAST_INSERT_ID(),
                createdBy=?<sql:param value="${userName}"/>,
                creationTS=NOW();
            </sql:update>
            <c:set var="hardware" value="${hardwareQ.rows[0]}"/>
        </sql:transaction>
        <c:redirect url="displayHardware.jsp">
            <c:param name="hardwareId" value="${hardware.id}"/>
        </c:redirect>
    </body>
</html>
