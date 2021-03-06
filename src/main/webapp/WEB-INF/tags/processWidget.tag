<%-- 
    Document   : processWidget
    Created on : May 17, 2013, 11:01:58 AM
    Author     : focke
--%>

<%@tag description="Display various stuff about a Process" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="processId" required="true"%>
<%@attribute name="parentActivityId"%>
<%@attribute name="processEdgeId"%>

    <sql:query var="processQ" >
select P.*,
P.travelerActionMask&(select maskBit from InternalAction where name='setHardwareLocation') as setsLocation
from Process P
where id=?<sql:param value="${processId}"/>;
    </sql:query>
<c:set var="process" value="${processQ.rows[0]}"/>

<c:if test="${! empty process.description}">
    <c:out value="${process.description}" escapeXml="false"/>
    <br>
</c:if>

<c:if test="${! empty process.instructionsURL}">
    <a href="${process.instructionsURL}">Detailed Instructions</a>
</c:if>

<c:if test="${empty param.activityId}">
    <traveler:processPrereqWidget processId="${processId}"/>
    <c:if test="${processQ.rows[0].substeps == 'SELECTION' || processQ.rows[0].substeps == 'HARDWARE_SELECTION'}"><traveler:processSelectionWidget processId="${processId}"/></c:if>
    <traveler:processInputWidget processId="${processId}"/>
</c:if>

<c:if test="${process.setsLocation != 0}">
Component will move to <c:out value="${empty process.newLocation ? 'User Input' : process.newLocation}"/>
</c:if>