<%-- 
    Document   : closeoutActivity
    Created on : Apr 15, 2015, 11:12:22 AM
    Author     : focke
--%>

<%@tag description="Close out (successfully) an Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="activityId" required="true"%>

<ta:setActivityStatus activityId="${activityId}" status="success"/>

    <sql:query var="activityQ">
select A.*, 
P.travelerActionMask&(select maskBit from InternalAction where name='makeHardwareRelationship') as makesRelationship,
P.travelerActionMask&(select maskBit from InternalAction where name='breakHardwareRelationship') as breaksRelationship
from Activity A
inner join Process P on P.id=A.processId
where A.id=?<sql:param value="${param.activityId}"/>;
    </sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>
<c:if test="${activity.makesRelationShip != 0}">
    <sql:update>
update HardwareRelationship set 
begin=?<sql:param value="${activity.end}"/>
where 
id=?<sql:param value="${activity.hardwareRelationshipId}"/>;
    </sql:update>
</c:if>
<c:if test="${activity.breaksRelationship != 0}">
    <sql:update>
update HardwareRelationship set 
end=?<sql:param value="${activity.end}"/>
where 
id=?<sql:param value="${activity.hardwareRelationshipId}"/>;
    </sql:update>
</c:if>
