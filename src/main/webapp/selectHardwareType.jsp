<%-- 
    Document   : selectHardwareType
    Created on : Jan 29, 2013, 10:38:59 AM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Select HardwareType</title>
    </head>
    <body>
        <traveler:checkFreshness formToken="${param.freshnessToken}"/>
        
        <h1>Pick a Hardware type.</h1>
        
        <sql:query var="hwTypesQ" >
           select id, name from HardwareType order by name;
        </sql:query>

        <form METHOD=GET ACTION="${param.target}">
            <input type="hidden" name="freshnessToken" value="${freshnessToken}">
            Type: <select name="hardwareTypeId">
                <c:forEach var="hRow" items="${hwTypesQ.rows}">
                    <option value="${hRow.id}">${hRow.name}</option>
                </c:forEach>
            </select>
            <INPUT TYPE=SUBMIT value="Go!">
        </form>        
        
    </body>
</html>
