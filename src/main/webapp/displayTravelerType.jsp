<%-- 
    Document   : displayTravelerType
    Created on : Apr 6, 2015, 11:08:31 AM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>

<sql:query var="ttQ">
    select 
        TT.*,
        P.id as processId, P.name
    from
        TravelerType TT
        inner join Process P on P.id=TT.rootProcessId
    where
        TT.id=?<sql:param value="${param.travelerTypeId}"/>
    ;
</sql:query>
<c:set var="travelerType" value="${ttQ.rows[0]}"/>

<c:url var="processLink" value="displayProcess.jsp">
    <c:param name="processPath" value="${travelerType.rootProcessId}"/>
</c:url>

<traveler:countSteps var="nSteps" processId="${travelerType.processId}"/>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Traveler Type <c:out value="${travelerType.name}"/></title>
    </head>
    <body>
        <h1>Traveler Type <c:out value="${travelerType.name}"/></h1>
        Root Process: <a href="${processLink}"><c:out value="${travelerType.name}"/></a><br>
        Steps: ${nSteps}<br>
        State: <c:out value="${travelerType.state}"/><br>
        Owner: <c:out value="${travelerType.owner}"/><br>
        Reason: <c:out value="${travelerType.reason}"/><br>
        Creator: <c:out value="${travelerType.createdBy}"/><br>
        Date: <c:out value="${travelerType.creationTS}"/><br>

        <traveler:travelerTypeStatusForm travelerTypeId="${param.travelerTypeId}"/>
    </body>
</html>
