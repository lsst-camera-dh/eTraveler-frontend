<%-- 
    Document   : retryActivity
    Created on : Feb 20,2014 15:19 PST
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>

<sql:transaction>
    <sql:update >
        update Activity set
        activityFinalStatusId=(select id from ActivityFinalStatus where name='superseded'),
        end=now(),
        closedBy=?<sql:param value="${userName}"/>
        where id=?<sql:param value="${activityId}"/>;
    </sql:update>

    <sql:query var="activityQ" >
        select A.*
        from Activity A
        where A.id=?<sql:param value="${activityId}"/>;
    </sql:query>
    <c:set var="activity" value="${activityQ.rows[0]}"/>

    <sql:update>
        insert into Activity set
        hardwareId=?<sql:param value="${activity.hardwareId}"/>,
        hardwareRelationshipId=?<sql:param value="${activity.hardwareRelationshipId}"/>,
        processId=?<sql:param value="${activity.processId}"/>,
        processEdgeId=?<sql:param value="${activity.processEdgeId}"/>,
        parentActivityId=?<sql:param value="${activity.parentActivityId}"/>,
        iteration=?<sql:param value="${activity.iteration + 1}"/>,
        inNCR=?<sql:param value="${activity.inNCR}"/>,
        createdBy=?<sql:param value="${userName}"/>,
        creationTS=now();
    </sql:update>
</sql:transaction>

<traveler:findTraveler var="travelerId" activityId="${activityId}"/>
<traveler:isStopped var="isStopped" activityId="${travelerId}"/>
<c:if test="${isStopped}">
    <traveler:restartActivity activityId="${travelerId}"/>
</c:if>
