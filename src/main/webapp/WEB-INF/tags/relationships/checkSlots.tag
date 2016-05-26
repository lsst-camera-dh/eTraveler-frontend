<%-- 
    Document   : checkSlots
    Created on : May 17, 2016, 3:59:45 PM
    Author     : focke
--%>

<%@tag description="sanity-check requested rel. actions vs slot status" pageEncoding="UTF-8"%>
<%-- This does not check the database state. It checks that currently requested actions make sense
     in light of the slot state as inferred from the presumed-sane DB. --%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="relationships" tagdir="/WEB-INF/tags/relationships"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="isSane" scope="AT_BEGIN"%>

<%-- find any requested actions which have not been done by this activity --%>
<%-- Assume corresponding slots exist --%>
<relationships:findUndoneActions var="actionsQ" activityId="${activityId}"/>

<c:set var="isSane" value="true"/>
<c:forEach var="action" items="${actionsQ.rows}">
    <relationships:checkAction var="message" action="${action.name}" slotId="${action.slotId}"/>
    <c:if test="${! empty message}">
        <c:set var="isSane" value="false"/>
        <h1>Relationship error!</h1>
        ${message}<br>
        <relationships:showSlotHistory slotId="${action.slotId}"/>
    </c:if>
</c:forEach>
