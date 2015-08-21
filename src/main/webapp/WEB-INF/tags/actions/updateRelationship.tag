<%-- 
    Document   : updateHardwareRelationship
    Created on : Jul 28, 2015, 5:31:05 PM
    Author     : focke
--%>

<%@tag description="Add to the history of a HardwareRelationship" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="slotId" required="true"%>
<%@attribute name="action" required="true"%>
<%@attribute name="activityId"%>

    <sql:update>
insert into MultiRelationshipHistory set
multiRelationshipSlotId=?<sql:param value="${slotId}"/>,
multiRelationshipActionId=(select id from MultiRelationshipAction where name=?<sql:param value="${action}"/>),
activityId=?<sql:param value="${activityId}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=utc_timestamp()
;
    </sql:update>