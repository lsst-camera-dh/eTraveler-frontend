<%-- 
    Document   : listHardwareTypes
    Created on : Apr 2, 2013, 3:39:09 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="filter" uri="http://srs.slac.stanford.edu/filter"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Hardware Types</title>
    </head>
    <body>
        <h1>Hardware Types</h1>
        <filter:filterTable>
            <filter:filterInput var="name" title="Name (substring search)"/>
        </filter:filterTable>
        <traveler:hardwareTypeList name="${name}"/>
    </body>
</html>
