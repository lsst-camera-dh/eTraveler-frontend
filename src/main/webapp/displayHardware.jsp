<%-- 
    Document   : displayHardware
    Created on : Jan 15, 2013, 12:36:21 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="batch" tagdir="/WEB-INF/tags/batches"%>
<%@taglib prefix="relationships" tagdir="/WEB-INF/tags/relationships"%>

<traveler:fullRequestString var="thisPage"/>
<traveler:checkSsPerm var="mayOperate" hardwareId="${param.hardwareId}" roles="operator,supervisor"/>

<traveler:checkId table="Hardware" id="${param.hardwareId}"/>
<sql:query var="hardwareQ">
    select H.*, HT.name as hardwareTypeName, HT.isBatched
    from Hardware H
    inner join HardwareType HT on HT.id=H.hardwareTypeId
    where H.id=?<sql:param value="${param.hardwareId}"/>
</sql:query>
<c:set var="hardware" value="${hardwareQ.rows[0]}"/>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title><c:out value="${hardware.hardwareTypeName} ${hardware.lsstId}"/></title>
    </head>
    <body>
        <h1>Component <c:out value="${hardware.lsstId}"/></h1>

        <traveler:hardwareHeader hardwareId="${param.hardwareId}"/>
        
        <h2>Status</h2>
        <traveler:hardwareStatusWidget hardwareId="${param.hardwareId}"/>
        
        <c:if test="${hardware.isBatched != 0}">
            <batch:batchWidget varTotal="quantity" hardwareId="${param.hardwareId}"/>
        </c:if>

        <h2>Generic Labels</h2>
	<traveler:genericLabelWidget objectId="${param.hardwareId}"
                                     objectTypeName="hardware" />
        
        <h2>Location</h2>
        <traveler:hardwareLocationWidget hardwareId="${param.hardwareId}"/>
        
        <h2>Travelers</h2>
        <traveler:newTravelerForm hardwareTypeId="${hardwareTypeId}" hardwareId="${param.hardwareId}"/>
        <traveler:activityList travelersOnly="true" hardwareId="${param.hardwareId}"/>

        <h2>Local Identifiers</h2>
        <sql:query var="identifiersQ" >
            select HI.identifier, HIA.name
            from HardwareIdentifier HI, HardwareIdentifierAuthority HIA
            where HI.hardwareId=?<sql:param value="${param.hardwareId}"/>
            and HIA.id=HI.authorityId;
        </sql:query>
        <display:table name="${identifiersQ.rows}" class="datatable">
            <display:column property="identifier"/>
            <display:column property="name" title="IdAuth"/>
        </display:table>
            
        <sql:query var="idAuthQ" >
           select * from HardwareIdentifierAuthority 
           where
           id not in (select HIA.id from 
                HardwareIdentifierAuthority HIA, HardwareIdentifier HI
                where
                HI.hardwareId=?<sql:param value="${param.hardwareId}"/>
                and
                HIA.id=HI.authorityId)
            order by name;
        </sql:query>
        <c:if test="${not empty idAuthQ.rows}">
            <form METHOD=GET ACTION="operator/addIdentifier.jsp">
                <input type="hidden" name="freshnessToken" value="${freshnessToken}">
                <input type="hidden" name="referringPage" value="${thisPage}">
                <input type="hidden" name="hardwareId" value="${param.hardwareId}">
                <input type="hidden" name="hardwareTypeId" value="${hardwareTypeId}">

                Identifier: <INPUT TYPE=TEXT NAME=identifier SIZE=20 required>

                Identifier Authority: <select name="authId">
                <c:forEach var="iaRow" items="${idAuthQ.rows}">
                    <option value="${iaRow.id}" <c:if test="${preferences.idAuthName==iaRow.name}">selected</c:if>>${iaRow.name}</option>
                </c:forEach>
                </select>

                <INPUT TYPE=SUBMIT value="Add Identifier"
                    <c:if test="${! mayOperate}">disabled</c:if>>
            </form>
        </c:if>
        
        <relationships:parentHistory hardwareId="${param.hardwareId}"/>
                
        <relationships:childHistory hardwareId="${param.hardwareId}"/>

        <h2>Recent Activities</h2>
        <traveler:activityList hardwareId="${param.hardwareId}"/>
        
        <traveler:eclWidget
            author="${userName}"
            hardwareTypeId="${hardwareTypeId}"
            hardwareId="${param.hardwareId}"
            />
        
    </body>
</html>
