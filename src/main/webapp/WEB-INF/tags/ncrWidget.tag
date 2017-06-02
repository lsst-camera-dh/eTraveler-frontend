<%-- 
    Document   : ncrWidget
    Created on : May 17, 2016, 10:35:49 AM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>

    <sql:query var="activityQ">
select A.*
from Activity A
where A.id = ?<sql:param value="${activityId}"/>
    </sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<c:if test="${activity.inNCR}">
    <traveler:findNcrParent var="travelerId" activityId="${activityId}"/>
    <c:choose>
        <c:when test="${! empty travelerId}">
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
    
    <c:if test="${activityId == activity.rootActivityId}">
        <sql:query var="exceptionQ">
            select id from Exception where NCRActivityId = ?<sql:param value="${activityId}"/>
        </sql:query>
        <c:set var="exceptionId" value="${exceptionQ.rows[0].id}"/>
        
        <traveler:genericLabelWidget objectId="${exceptionId}"
                                     objectTypeName="NCR" />
    </c:if>
</c:if>