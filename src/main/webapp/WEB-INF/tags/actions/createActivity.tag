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
<%@attribute name="iteration"%>
<%@attribute name="jobHarnessId"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="activityId" scope="AT_BEGIN"%>

<c:if test="${empty jobHarnessId && ! empty parentActivityId}">
    <sql:query var="jhQ">
select jobHarnessId from Activity where id = ?<sql:param value="${parentActivityId}"/>;
    </sql:query>
    <c:set var="jobHarnessId" value="${jhQ.rows[0].jobHarnessId}"/>
</c:if>

<c:if test="${! empty parentActivityId}">
    <sql:query var="rootQ">
select rootActivityId from Activity where id = ?<sql:param value="${parentActivityId}"/>;
    </sql:query>
    <c:set var="rootActivityId" value="${rootQ.rows[0].rootActivityId}"/>
</c:if>
    <sql:update >
insert into Activity set
hardwareId=?<sql:param value="${hardwareId}"/>,
processId=?<sql:param value="${processId}"/>,
<c:if test="${! empty processEdgeId}">
    processEdgeId = ?<sql:param value="${processEdgeId}"/>,
</c:if>
<c:if test="${! empty parentActivityId}">
    parentActivityId = ?<sql:param value="${parentActivityId}"/>,
    rootActivityId = ?<sql:param value="${rootActivityId}"/>,
</c:if>
<c:if test="${! empty jobHarnessId}">
    jobHarnessId = ?<sql:param value="${jobHarnessId}"/>,
</c:if>
<c:if test="${! empty iteration}">
    iteration = ?<sql:param value="${iteration}"/>,
</c:if>
inNCR = ?<sql:param value="${inNCR}"/>,
createdBy = ?<sql:param value="${userName}"/>,
creationTS = UTC_TIMESTAMP();
    </sql:update>
    <sql:query var="activityQ">
select last_insert_id() as activityId;
    </sql:query>
<c:set var="activityId" value="${activityQ.rows[0].activityId}"/>
<c:if test="${empty parentActivityId}">
    <sql:update>
update Activity set rootActivityId = id where id = ?<sql:param value="${activityId}"/>;
    </sql:update>
</c:if>

    <sql:update>
insert into ActivityStatusHistory set
activityStatusId = (select id from ActivityFinalStatus where name = 'new'),
activityId = ?<sql:param value="${activityId}"/>,
createdBy = ?<sql:param value="${userName}"/>,
creationTS = utc_timestamp();
    </sql:update>
