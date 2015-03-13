<%-- 
    Document   : registerHardware
    Created on : Jan 30, 2013, 2:15:51 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
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
