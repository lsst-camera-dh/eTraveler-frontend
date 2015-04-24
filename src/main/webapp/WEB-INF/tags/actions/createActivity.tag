<%-- 
    Document   : createActivity
    Created on : Aug 8, 2014, 1:54:24 PM
    Author     : focke
--%>

<%@tag description="Create a new Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="hardwareId" required="true"%>
<%@attribute name="processId" required="true"%>
<%@attribute name="inNCR" required="true"%>
<%@attribute name="parentActivityId"%>
<%@attribute name="processEdgeId"%>
<%@attribute name="hardwareRelationshipId"%>
<%@attribute name="iteration"%>

<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="activityId" scope="AT_BEGIN"%>

    <sql:update >
insert into Activity set
hardwareId=?<sql:param value="${hardwareId}"/>,
<c:if test="${! empty hardwareRelationshipId}">
    hardwareRelationshipId=?<sql:param value="${hardwareRelationshipId}"/>,
</c:if>
processId=?<sql:param value="${processId}"/>,
<c:if test="${! empty parentActivityId}">
    parentActivityId=?<sql:param value="${parentActivityId}"/>,
</c:if>
<c:if test="${! empty processEdgeId}">
    processEdgeId=?<sql:param value="${processEdgeId}"/>,
</c:if>
inNCR=?<sql:param value="${inNCR}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=UTC_TIMESTAMP();
    </sql:update>
    <sql:query var="activityQ">
select last_insert_id() as activityId;
    </sql:query>

<c:set var="activityId" value="${activityQ.rows[0].activityId}"/>

    <sql:update>
insert into ActivityStatusHistory set
activityStatusId=(select id from ActivityFinalStatus where name='new'),
activityId=?<sql:param value="${activityId}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=utc_timestamp();
    </sql:update>
