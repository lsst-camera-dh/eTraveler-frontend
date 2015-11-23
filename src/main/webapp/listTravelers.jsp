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

    <sql:query var="statesQ">
select name from ActivityFinalStatus order by name;
    </sql:query>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Traveler List 
            <c:if test="${! empty param.processId}">
                <sql:query var="processQ" >
                    select name from Process where id=?<sql:param value="${param.processId}"/>
                </sql:query>
                for type <c:out value="${processQ.rows[0].name}"/>
            </c:if>
        </title>
    </head>
    <body>
        <filter:filterTable>
            <filter:filterInput var="name" title="Name (substring search)"/>
            <filter:filterInput var="cSerial" title="Camera Serial"/>
            <filter:filterInput var="mSerial" title="Manufacturer Serial"/>
            <filter:filterInput var="type" title="Component Type"/>
            <filter:filterInput var="userId" title="User"/>
            <filter:filterSelection title="Status" var="status" defaultValue='any'>
                <filter:filterOption value="any">Any</filter:filterOption>
                <c:forEach var="statusName" items="${statesQ.rows}">
                    <filter:filterOption value="${statusName.name}"><c:out value="${statusName.name}"/></filter:filterOption>
                </c:forEach>
            </filter:filterSelection>
            <filter:filterSelection title="Version" var="version" defaultValue='all'>
                <filter:filterOption value="latest">Latest</filter:filterOption>
                <filter:filterOption value="all">All</filter:filterOption>
            </filter:filterSelection>
        </filter:filterTable>
        <traveler:activityList travelersOnly="true" version="${version}" processId="${param.processId}" 
                               done="${param.done}" status="${status}" hardwareId="${param.hardwareId}" name="${name}"
                               camSerial="${cSerial}" manSerial="${mSerial}" type="${type}" userId="${userId}"/>
    </body>
</html>
