<%-- 
    Document   : fail
    Created on : Nov 13, 2013, 12:00:53 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>
<%@attribute name="status"%>

<c:if test="${empty status}">
    <c:set var="status" value="failed"/>
</c:if>

<sql:query var="activityQ">
    select A.*, P.maxIteration
    from Activity A
    inner join Process P on P.id=A.processId
    where A.id=?<sql:param value="${activityId}"/>
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>
    
<c:choose>
    <c:when test="${status == 'failure' && activity.iteration < activity.maxIteration}">
        <traveler:retryActivity activityId="${activityId}"/>
    </c:when>
    <c:otherwise>
        <sql:update >
            update Activity set
            activityFinalStatusId=(select id from ActivityFinalStatus where name=?<sql:param value="${status}"/>),
            <c:if test="${empty activity.begin}">begin=now(),</c:if>
            end=now(),
            closedBy=?<sql:param value="${userName}"/>
            where id=?<sql:param value="${activityId}"/>;
        </sql:update>

        <sql:query var="activityQ" >
            select A.*
            from Activity A
            where A.id=?<sql:param value="${activityId}"/>;
        </sql:query>
        <c:if test="${! empty activityQ.rows[0].parentActivityId}">
            <traveler:failActivity activityId="${activityQ.rows[0].parentActivityId}" status="${status}"/>
        </c:if>
    </c:otherwise>
</c:choose>