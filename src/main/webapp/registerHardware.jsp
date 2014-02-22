<%-- 
    Document   : initiateTraveller
    Created on : Jan 30, 2013, 2:15:51 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Register Hardware</title>
    </head>
    <body>

        <traveler:newHardwareForm hardwareTypeId="${param.hardwareTypeId}"/>
            
    </body>
</html>
