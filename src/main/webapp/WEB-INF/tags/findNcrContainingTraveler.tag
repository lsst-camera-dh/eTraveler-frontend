<%-- 
    Document   : findNcrContainingTraveler
    Created on : May 17, 2016, 10:35:49 AM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="travelerId" scope="AT_BEGIN"%>

    <sql:query var="activityQ">
select A.inNCR
from Activity A
where A.id = ?<sql:param value="${activityId}"/>
    </sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<c:choose>
    <c:when test="${activity.inNCR}">
        <traveler:findTraveler var="ncrId" activityId="${activityId}"/>
        <sql:query var="exceptionQ">
select E.exitActivityId
from Exception E
where E.ncrActivityId = ?<sql:param value="${ncrId}"/>
        </sql:query>
        <c:choose>
            <c:when test="${! empty exceptionQ.rows}">
                <c:set var="exception" value="${exceptionQ.rows[0]}"/>
                <traveler:findTraveler var="travelerId" activityId="${exception.exitActivityId}"/>
            </c:when>
            <c:otherwise>
                <c:set var="travelerId" value=""/>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <c:set var="travelerId" value=""/>
    </c:otherwise>
</c:choose>