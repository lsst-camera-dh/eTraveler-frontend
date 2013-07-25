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
        <title>Initiate Traveler</title>
    </head>
    <body>

        <sql:query var="processQ" dataSource="jdbc/rd-lsst-cam">
            select * from Process where id=?<sql:param value="${param.processId}"/>;
        </sql:query>
        <c:set var="process" value="${processQ.rows[0]}"/>
        <sql:query var="hardwareQ" dataSource="jdbc/rd-lsst-cam">
            select H.*, HT.name as typeName from Hardware H, HardwareType HT
            where 
            HT.id=H.hardwareTypeId
            and
            H.hardwareTypeId=?<sql:param value="${process.hardwareTypeId}"/>;
        </sql:query>
       
        <h1>
        Initiating Traveler type 
        &lt;<c:out value="${process.name}"/>&gt;
        for Hardware type
        &lt;<c:out value="${hardwareQ.rows[0]['typeName']}"/>&gt;
        </h1>
        
        <form METHOD=GET ACTION="createTraveler.jsp">
            <input type="hidden" name="processId" value="${param.processId}"/>

            Component: 
            <select name="hardwareId">
                <c:forEach var="hRow" items="${hardwareQ.rows}">
                    <option value="${hRow.id}">${hRow.lsstId}</option>
                </c:forEach>
            </select>

            In NCR?
            <input type="radio" name="inNCR" value="FALSE" checked="true"/>No
            <input type="radio" name="inNCR" value="TRUE"/>Yes

            <INPUT TYPE=SUBMIT value="Begin Process">
        </form>
    </body>
</html>
