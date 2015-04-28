<%-- 
    Document   : listTravelerTypes
    Created on : Apr 2, 2013, 3:39:09 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="filter" uri="http://srs.slac.stanford.edu/filter"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

    <sql:query var="statesQ">
select name from TravelerTypeState order by name;
    </sql:query>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Traveler Types</title>
    </head>
    <body>
        <h1>Traveler Types</h1>
        <c:choose>
            <c:when test="${! empty param.state}">
                <c:set var="theState" value="${param.state}"/>
            </c:when>
            <c:otherwise>
                <c:set var="theState" value="active"/>
            </c:otherwise>
        </c:choose>
        
        <filter:filterTable>
            <filter:filterSelection title="State" var="state" defaultValue='${theState}'>
                <filter:filterOption value="any">Any</filter:filterOption>
                <c:forEach var="stateName" items="${statesQ.rows}">
                    <filter:filterOption value="${stateName.name}"><c:out value="${stateName.name}"/></filter:filterOption>
                </c:forEach>
            </filter:filterSelection>
            <filter:filterSelection title="Version" var="version" defaultValue='all'>
                <filter:filterOption value="latest">Latest</filter:filterOption>
                <filter:filterOption value="all">All</filter:filterOption>
            </filter:filterSelection>
        </filter:filterTable>
        <traveler:travelerTypeList hardwareTypeId="${param.hardwareTypeId}" version="${version}" state="${state}"/>
    </body>
</html>
