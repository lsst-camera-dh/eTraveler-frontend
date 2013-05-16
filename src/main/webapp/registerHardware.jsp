<%-- 
    Document   : initiateTraveller
    Created on : Jan 30, 2013, 2:15:51 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Register Hardware</title>
    </head>
    <body>

        <sql:query var="typesQ" dataSource="jdbc/rd-lsst-cam">
            select * from HardwareType;
        </sql:query>
        
        <form METHOD=GET ACTION="createHardware.jsp">

            Identifier: 
            <INPUT TYPE=TEXT NAME=lsstId SIZE=50 autofocus>
            
            Type: 
            <select name="typeId">
                <c:forEach var="tRow" items="${typesQ.rows}">
                    <option value="${tRow.id}">${tRow.name}</option>
                </c:forEach>
            </select>

            <INPUT TYPE=SUBMIT value="Do It!">
        </form>
    </body>
</html>
