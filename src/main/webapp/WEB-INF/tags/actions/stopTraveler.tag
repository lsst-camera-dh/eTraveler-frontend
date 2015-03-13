<%-- 
    Document   : stopTraveler
    Created on : Jun 5, 2014, 4:37:57 PM
    Author     : focke
--%>

<%@tag description="Stop Work on a process traveler" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="mask" required="true"%>
<%@attribute name="reason" required="true"%>
<%@attribute name="travelerId"%>

<c:if test="${empty travelerId}">
    <traveler:findTraveler var="travelerId" activityId="${activityId}"/>
</c:if>

<sql:update>
    insert into StopWorkHistory set
    activityId=?<sql:param value="${activityId}"/>,
    rootActivityId=?<sql:param value="${travelerId}"/>,
    reason=?<sql:param value="${reason}"/>,
    approvalGroup=?<sql:param value="${mask}"/>,
    creationTS=UTC_TIMESTAMP(),
    createdBy=?<sql:param value="${userName}"/>;
</sql:update>

<ta:stopActivity activityId="${travelerId}"/>
