<%-- 
    Document   : selectHardwareType
    Created on : Jan 29, 2013, 10:38:59 AM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Select HardwareType</title>
    </head>
    <body>
        <h1>Pick a Hardware type.</h1>
        
        <sql:query var="hwTypesQ" >
           select id, name from HardwareType;
        </sql:query>

        <form METHOD=GET ACTION="${param.target}">
            Type: <select name="hardwareTypeId">
                <c:forEach var="hRow" items="${hwTypesQ.rows}">
                    <option value="${hRow.id}">${hRow.name}</option>
                </c:forEach>
            </select>
            <INPUT TYPE=SUBMIT value="Go!">
        </form>        
        
    </body>
</html>
