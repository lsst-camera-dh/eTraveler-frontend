<%-- 
    Document   : updateRelationship
    Created on : Jul 28, 2015, 5:31:05 PM
    Author     : focke
--%>

<%@tag description="Add to the history of a MultiRelationship" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="slotId" required="true"%>
<%@attribute name="action" required="true"%>
<%@attribute name="minorId" required="true"%>
<%@attribute name="activityId"%>
<%@attribute name="reason"%>

    <sql:update>
insert into MultiRelationshipHistory set
multiRelationshipSlotId=?<sql:param value="${slotId}"/>,
minorId=?<sql:param value="${minorId}"/>,
multiRelationshipActionId=(select id from MultiRelationshipAction where name=?<sql:param value="${action}"/>),
activityId=?<sql:param value="${activityId}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=utc_timestamp()
;
    </sql:update>

<c:if test="${empty reason && ! empty activityId}">
    <c:url var="activityUrl" value="displayActivity.jsp">
        <c:param name="activityId" value="${activityId}"/>
    </c:url>
    <sql:query var="activityQ">
select P.name
from Activity A
inner join Process P on P.id = A.processId
where A.id = ?<sql:param value="${activityId}"/>
;
    </sql:query>
    <c:set var="activityLink" value="<a href='${activityUrl}'>${activityQ.rows[0].name}</a>"/>
    <c:set var="reason" value="${action}ed by Activity ${activityLink}"/>
</c:if>

<c:choose>
    <c:when test="${action == 'assign'}">
        <c:set var="newStatus" value="USED"/>
    </c:when>
    <c:when test="${action == 'deassign' || action == 'uninstall'}">
        <c:set var="newStatus" value="PENDING"/>
    </c:when>
</c:choose>
<c:if test="${! empty newStatus}">
    <ta:setHardwareStatus hardwareId="${minorId}" 
                          hardwareStatusName="${newStatus}" 
                          activityId="${activityId}" 
                          reason="${reason}"/>
</c:if>
