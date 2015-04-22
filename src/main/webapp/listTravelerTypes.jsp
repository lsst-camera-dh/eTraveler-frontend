<%-- 
    Document   : listTravelerTypes
    Created on : Apr 2, 2013, 3:39:09 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="filter" uri="http://srs.slac.stanford.edu/filter"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Traveler Types</title>
    </head>
    <body>
        <h1>Traveler Types</h1>
        <filter:filterTable>
            <filter:filterSelection title="Version" var="version" defaultValue='latest'>
                <filter:filterOption value="latest">Latest</filter:filterOption>
                <filter:filterOption value="all">All</filter:filterOption>
            </filter:filterSelection>
        </filter:filterTable>
        <traveler:travelerTypeList hardwareTypeId="${param.hardwareTypeId}" version="${version}" state="${param.state}"/>
    </body>
</html>
