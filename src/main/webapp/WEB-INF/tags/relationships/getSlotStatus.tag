<%-- 
    Document   : getSlotStatus
    Created on : May 19, 2016, 10:41:40 AM
    Author     : focke
--%>

<%@tag description="Find the current status of a slot" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="slotId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="status" scope="AT_BEGIN"%>
<%@attribute name="varId" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="varId" alias="minorId" scope="AT_BEGIN"%>

    <sql:query var="statusQ">
select MRA.name, MRH.minorId
from MultiRelationshipHistory MRH
inner join MultiRelationshipAction MRA on MRA.id = MRH.multiRelationshipActionId
where MRH.multiRelationshipSlotId = ?<sql:param value="${slotId}"/>
order by MRH.id desc limit 1
;
    </sql:query>

<c:set var="lastAction" value="${empty statusQ.rows ? 'Nothing' : statusQ.rows[0].name}"/>

<c:choose>
    <c:when test="${lastAction == 'Nothing' || lastAction == 'deassign' || lastAction == 'uninstall'}">
        <c:set var="status" value="free"/>
    </c:when>
    <c:when test="${lastAction == 'assign'}">
        <c:set var="status" value="assigned"/>
        <c:set var="minorId" value="${statusQ.rows[0].minorId}"/>
    </c:when>
    <c:when test="${lastAction == 'install'}">
        <c:set var="status" value="occupied"/>
        <c:set var="minorId" value="${statusQ.rows[0].minorId}"/>
    </c:when>
</c:choose>
