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
<%@attribute name="varTraveler" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="varTraveler" alias="runTravelerId" scope="AT_BEGIN"%>
<%@attribute name="varRun" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="varRun" alias="runNumber" scope="AT_BEGIN"%>

<traveler:findTraveler var="travelerId" activityId="${activityId}"/>

    <sql:query var="activityQ">
select A.inNCR
from Activity A
where A.id = ?<sql:param value="${travelerId}"/>
    </sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<c:choose>
    <c:when test="${activity.inNCR}">
        <sql:query var="exceptionQ">
select E.exitActivityId
from Exception E
where E.ncrActivityId = ?<sql:param value="${travelerId}"/>
        </sql:query>
        <c:choose>
            <c:when test="${! empty exceptionQ.rows}">
                <c:set var="exception" value="${exceptionQ.rows[0]}"/>
                <c:choose>
                    <c:when test="${exception.exitActivityId == travelerId}">
                        <c:set var="runTravelerId" value="${travelerId}"/>
                    </c:when>
                    <c:otherwise>
                        <traveler:findTraveler var="runTravelerId" activityId="${exception.exitActivityId}"/>
                        <traveler:findRun varTraveler="runTravelerId" varRun="junk" activityId="${runTravelerId}"/>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:otherwise>
                <c:set var="runTravelerId" value="${travelerId}"/>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <c:set var="runTravelerId" value="${travelerId}"/>
    </c:otherwise>
</c:choose>

    <sql:query var="runQ">
select runNumber from RunNumber where rootActivityId = ?<sql:param value="${runTravelerId}"/>;
    </sql:query>
<c:set var="runNumber" value="${runQ.rows[0].runNumber}"/>
