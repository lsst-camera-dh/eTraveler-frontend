<%-- 
    Document   : findTraveler
    Created on : Apr 18, 2014, 2:14:56 PM
    Author     : focke
--%>

<%@tag description="Find the root Activity of a process traveler from any Activity in it" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="travelerId" scope="AT_BEGIN"%>

<sql:query var="activityQ">
    select * from Activity where id=?<sql:param value="${activityId}"/>;
</sql:query>

<c:choose>
    <c:when test="${empty activityQ.rows[0].parentActivityId}">
        <c:set var="travelerId" value="${activityId}"/>
    </c:when>
    <c:otherwise>
        <traveler:findTraveler var="travelerId" activityId="${activityQ.rows[0].parentActivityId}"/>
    </c:otherwise>
</c:choose>
