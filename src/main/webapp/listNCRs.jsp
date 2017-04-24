<%-- 
    Document   : listTravelers
    Created on : Jan 30, 2013, 3:51:03 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="filter" uri="http://srs.slac.stanford.edu/filter"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>NCR List 
        </title>
    </head>
    <body>
        <filter:filterTable>
            <filter:filterInput var="traveler" title="Traveler"/>
            <filter:filterInput var="exception" title="Exception"/>
            <filter:filterInput var="parent" title="Parent"/>
            <filter:filterInput var="component" title="Component"/>
            <filter:filterInput var="type" title="Component Type"/>
        </filter:filterTable>
                
        <traveler:ncrList exceptionName="${exception}" travelerName="${traveler}" 
                          parentName="${parent}" componentName="${component}" componentType="${type}"/>
    </body>
</html>
