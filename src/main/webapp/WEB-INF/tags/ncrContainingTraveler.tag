<%-- 
    Document   : ncrContainingTraveler
    Created on : May 17, 2016, 10:35:49 AM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>

    <sql:query var="activityQ">
select A.inNCR
from Activity A
where A.id = ?<sql:param value="${activityId}"/>
    </sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<c:if test="${activity.inNCR}">
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
            <sql:query var="processQ">
        select P.name
        from Activity A
        inner join Process P on P.id = A.processId
        where A.id = ?<sql:param value="${travelerId}"/>
            </sql:query>
            <c:set var="process" value="${processQ.rows[0]}"/>
            <c:url var="travelerLink" value="displayActivity.jsp">
                <c:param name="activityId" value="${travelerId}"/>
            </c:url>
            <h2>This is an NCR for traveler: <a href="${travelerLink}">${process.name}</a></h2>
        </c:when>
        <c:otherwise>
            <h2>This is a standalone NCR</h2>
        </c:otherwise>
    </c:choose>
</c:if>