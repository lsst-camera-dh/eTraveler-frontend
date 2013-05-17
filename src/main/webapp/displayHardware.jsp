<%-- 
    Document   : displayHardware
    Created on : Jan 15, 2013, 12:36:21 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Hardware</title>
    </head>
    <body>
        <h1>Hardware!</h1>

        <traveler:hardwareHeader hardwareId="${param.hardwareId}"/>

        <h2>Nicknames</h2>
        <sql:query var="identifiersQ" dataSource="jdbc/rd-lsst-cam">
            select HI.identifier, HIA.name
            from HardwareIdentifier HI, HardwareIdentifierAuthority HIA
            where HI.hardwareId=?<sql:param value="${param.hardwareId}"/>
            and HIA.id=HI.authorityId;
        </sql:query>
        <display:table name="${identifiersQ.rows}" class="datatable">
            <display:column property="identifier"/>
            <display:column property="name" title="IdAuth"/>
        </display:table>
            
        <sql:query var="idAuthQ" dataSource="jdbc/rd-lsst-cam">
           select * from HardwareIdentifierAuthority 
           where
           id not in (select HIA.id from 
                HardwareIdentifierAuthority HIA, HardwareIdentifier HI
                where
                HI.hardwareId=?<sql:param value="${param.hardwareId}"/>
                and
                HIA.id=HI.authorityId);
        </sql:query>
        <c:if test="${not empty idAuthQ.rows}">
            <form METHOD=GET ACTION="addIdentifier.jsp">
                <input type="hidden" name="hardwareId" value="${param.hardwareId}">
                <input type="hidden" name="hardwareTypeId" value="${hardwareTypeId}">

                Identifier: <INPUT TYPE=TEXT NAME=identifier SIZE=20>

                Identifier Authority: <select name="authId">
                <c:forEach var="iaRow" items="${idAuthQ.rows}">
                    <option value="${iaRow.id}" <c:if test="${! empty sessionScope.siteName and sessionScope.siteName==iaRow.name}">selected</c:if>>${iaRow.name}</option>
                </c:forEach>
                </select>

                <INPUT TYPE=SUBMIT value="Add Nickname">
            </form>
        </c:if>
        
        <h2>Travelers</h2>
        <%--
        <sql:query var="travelersQ" dataSource="jdbc/rd-lsst-cam">
            select A.*, P.name from Activity A, Process P
            where
            P.id=A.processId
            and
            A.hardwareId=?<sql:param value="${param.hardwareId}"/>
            and
            A.processEdgeId is null;
        </sql:query>
        <display:table name="${travelersQ.rows}" class="datatable">
            <display:column property="name" title="Name" sortable="true" headerClass="sortable"
                            href="displayActivity.jsp" paramId="activityId" paramProperty="id"/>
            <display:column property="begin" sortable="true" headerClass="sortable"/>
            <display:column property="createdBy" sortable="true" headerClass="sortable"/>
            <display:column property="end" sortable="true" headerClass="sortable"/>
            <display:column property="closedBy" sortable="true" headerClass="sortable"/>
        </display:table>
        --%>
        <traveler:travelerList hardwareId="${param.hardwareId}"/>
        
        <sql:query var="applicableTTypesQ" dataSource="jdbc/rd-lsst-cam">
            select * from Process P
            where 
            P.id not in (select distinct child from ProcessEdge)
            and
            P.hardwareTypeId=?<sql:param value="${hardwareTypeId}"/>;
        </sql:query>
        <form method=GET action="createTraveler.jsp">
            <input type="hidden" name="hardwareId" value="${param.hardwareId}">
            <input type="hidden" name="inNCR" value="FALSE">
            Traveler Type: 
            <select name="processId">
                <c:forEach var="pRow" items="${applicableTTypesQ.rows}">
                    <option value="${pRow.id}">${pRow.name} v${pRow.version}</option>
                </c:forEach>
            </select>
            In NCR?
            <input type="radio" name="inNCR" value="FALSE" checked="true"/>No
            <input type="radio" name="inNCR" value="TRUE"/>Yes
            <input type="SUBMIT" value="Apply Traveler">
        </form>
                
        <h2>Component of</h2>
        <traveler:table hardwareId="${param.hardwareId}" mode="p"/>
                
        <h2>Components</h2>
        <traveler:table hardwareId="${param.hardwareId}" mode="c"/>
        
    </body>
</html>
