<%-- 
    Document   : listHardwareGroups
    Created on : Mar 12, 2015, 4:22:58 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="filter" uri="http://srs.slac.stanford.edu/filter"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hardware Groups</title>
    </head>
    <body>
        <h1>Hardware Groups</h1>
        <filter:filterTable>
            <filter:filterInput var="name" title="Name (substring search)"/>
        </filter:filterTable>
        <traveler:hardwareGroupList name="${name}"/>
    </body>
</html>
