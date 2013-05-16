<%-- 
    Document   : startProcess
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
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Pick a Traveler type to initiate.</h1>
        
            <%-- should make sure these are the latest versions --%>
        <sql:query var="process" dataSource="jdbc/rd-lsst-cam">
           select * from Process where
           Process.id not in (select distinct child from ProcessEdge);
        </sql:query>

        <form METHOD=GET ACTION="initiateTraveler.jsp">
            Process: <select name="processId">
                <c:forEach var="pRow" items="${process.rows}">
                    <option value="${pRow.id}">${pRow.name} v${pRow.version}</option>
                </c:forEach>
            </select>
            <INPUT TYPE=SUBMIT value="Initiate Traveller">
        </form>
        
        
    </body>
</html>
