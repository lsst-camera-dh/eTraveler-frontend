<%-- 
    Document   : listTravelerTypes
    Created on : Apr 2, 2013, 3:39:09 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Traveler Types</title>
    </head>
    <body>
        <h1>Traveler Types</h1>
        <traveler:travelerTypeList hardwareTypeId="${param.hardwareTypeId}" state="${param.state}"/>
    </body>
</html>
