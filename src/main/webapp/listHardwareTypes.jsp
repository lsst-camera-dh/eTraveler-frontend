<%-- 
    Document   : listHardwareTypes
    Created on : Apr 2, 2013, 3:39:09 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="filter" uri="http://srs.slac.stanford.edu/filter"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

    <sql:query var="subsysQ">
select name from Subsystem order by name;
    </sql:query>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Hardware Types</title>
    </head>
    <body>
        <h1>Hardware Types</h1>
        <filter:filterTable>
            <filter:filterInput var="name" title="Name/Description"/>
            <filter:filterSelection title="Subsystem" var="subsystem" defaultValue="${preferences.subsystem}">
                <filter:filterOption value="${preferences.subsystem}">User Pref</filter:filterOption>
                <filter:filterOption value="Any">Any</filter:filterOption>
                <c:forEach var="subsystem" items="${subsysQ.rows}">
                    <filter:filterOption value="${subsystem.name}"><c:out value="${subsystem.name}"/></filter:filterOption>
                </c:forEach>                
            </filter:filterSelection>
        </filter:filterTable>
        <traveler:hardwareTypeList name="${name}" subsystemName="${subsystem}"/>
    </body>
</html>
