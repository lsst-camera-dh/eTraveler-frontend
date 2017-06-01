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
        TTS.name as state,
        P.id as processId, concat(P.name, ' v', P.version) as name,
        SS.id as subsystemId, SS.name as subsystemName
    from
        TravelerType TT
        inner join TravelerTypeStateHistory TTSH on 
            TTSH.travelerTypeId=TT.id 
            and TTSH.id=(select max(id) from TravelerTypeStateHistory where travelerTypeId=TT.id)
        inner join TravelerTypeState TTS on TTS.id=TTSH.travelerTypeStateId
        inner join Process P on P.id=TT.rootProcessId
        inner join Subsystem SS on SS.id=TT.subsystemId
    where
        TT.id=?<sql:param value="${param.travelerTypeId}"/>
    ;
</sql:query>
<c:set var="travelerType" value="${ttQ.rows[0]}"/>

<c:url var="processLink" value="displayProcess.jsp">
    <c:param name="processPath" value="${travelerType.rootProcessId}"/>
</c:url>

<c:url var="subsysUrl" value="displaySubsystem.jsp">
    <c:param name="subsystemId" value="${travelerType.subsystemId}"/>
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
        Subsystem: <a href="${subsysUrl}">${travelerType.subsystemName}</a><br>
        Steps: ${nSteps}<br>
        State: <c:out value="${travelerType.state}"/><br>
        Owner: <c:out value="${travelerType.owner}"/><br>
        Reason: <c:out value="${travelerType.reason}"/><br>
        Creator: <c:out value="${travelerType.createdBy}"/><br>
        Date: <c:out value="${travelerType.creationTS}"/><br>

        <traveler:travelerTypeHistory travelerTypeId="${param.travelerTypeId}"/>
        <traveler:travelerTypeStatusForm travelerTypeId="${param.travelerTypeId}"/>

        <h2>Generic Labels</h2>
	<traveler:genericLabelWidget objectId="${param.travelerTypeId}"
                                     objectTypeName="travelerType" />
    </body>
</html>
