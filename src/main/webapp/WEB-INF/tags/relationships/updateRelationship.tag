<%-- 
    Document   : updateHardwareRelationship
    Created on : Jul 28, 2015, 5:31:05 PM
    Author     : focke
--%>

<%@tag description="Add to the history of a HardwareRelationship" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="slotId" required="true"%>
<%@attribute name="action" required="true"%>
<%@attribute name="minorId" required="true"%>
<%@attribute name="activityId"%>

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

<%-- set minor status --%>
<c:if test="${! empty activityId}">
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
</c:if>
<c:choose>
    <c:when test="${action == 'assign'}">
        <ta:setHardwareStatus hardwareId="${minorId}" hardwareStatusName="USED" activityId="${activityId}" reason="Assigned by Activity ${activityLink}"/>
    </c:when>
    <%-- TODO: what happens when minor is batched? --%>
    <c:when test="${action == 'deassign'}">
        <ta:setHardwareStatus hardwareId="${minorId}" hardwareStatusName="PENDING" activityId="${activityId}" reason="Deassigned by Activity ${activityLink}"/>
    </c:when>
    <c:when test="${action == 'uninstall'}">
        <ta:setHardwareStatus hardwareId="${minorId}" hardwareStatusName="PENDING" activityId="${activityId}" reason="Uninstalled by Activity ${activityLink}"/>
    </c:when>
</c:choose>
