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
        <traveler:travelerTypeList hardwareTypeId="${param.hardwareTypeId}"/>
    </body>
</html>
