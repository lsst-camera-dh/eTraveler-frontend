<%-- 
    Document   : checkAction
    Created on : May 19, 2016, 11:00:22 AM
    Author     : focke
--%>

<%@tag description="check whether it makes sense to perform an action on a slot" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="relationships" tagdir="/WEB-INF/tags/relationships"%>

<%@attribute name="action" required="true"%>
<%@attribute name="slotId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="message" scope="AT_BEGIN"%>

<relationships:getSlotStatus var="status" varId="minorId" slotId="${slotId}"/>

<c:if test="${! empty minorId}">
    <sql:query var="minorQ">
select lsstId from Hardware where id = ?<sql:param value="${minorId}"/>;
    </sql:query>
    <c:url var="minorUrl" value="displayHardware.jsp">
        <c:param name="hardwareId" value="${minorId}"/>
    </c:url>
    <c:set var="minorLink" value="<a href='${minorUrl}'>${minorQ.rows[0].lsstId}</a>"/>
</c:if>

<c:choose> 
    <c:when test="${action == 'assign'}">
        <c:choose>
            <c:when test="${status == 'assigned'}">
                <c:set var="message" value="Assign requested, but component ${minorLink} is already assigned."/>
            </c:when>
            <c:when test="${status == 'occupied'}">
                <c:set var="message" value="Assign requested, but component ${minorLink} is already installed."/>
            </c:when>
        </c:choose>
    </c:when>
    <c:when test="${action == 'deassign'}">
        <c:choose>
            <c:when test="${status == 'free'}">
                <c:set var="message" value="Unassign requested, but slot is free."/>
            </c:when>
            <c:when test="${status == 'occupied'}">
                <c:set var="message" value="Unassign requested, but slot is occupied by component ${minorLink}."/>
            </c:when>
        </c:choose>
    </c:when>
    <c:when test="${action == 'install'}">
        <c:if test="${status == 'occupied'}">
            <c:set var="message" value="Install requested, but component ${minorLink} is already installed."/>
        </c:if>
    </c:when>
    <c:when test="${(action == 'uninstall' and status != 'occupied')}">
        <c:set var="message" value="Uninstall requested, but nothing is installed."/>
    </c:when>
</c:choose>
