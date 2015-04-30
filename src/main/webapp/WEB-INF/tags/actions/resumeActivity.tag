<%-- 
    Document   : resumeActivity
    Created on : Apr 17, 2014, 3:53:34 PM
    Author     : focke
--%>

<%@tag description="Resume work on a stopped traveler." pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>

<sql:query var="activityQ">
    select * from Activity where id=?<sql:param value="${activityId}"/>
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<traveler:getActivityStatus var="status" activityId="${activityId}"/>

<sql:query var="lastStatusQ">
    select AFS.id, AFS.name
    from ActivityFinalStatus AFS
    inner join ActivityStatusHistory ASH on ASH.activityStatusId=AFS.id
    where ASH.activityId=?<sql:param value="${activityId}"/>
    and AFS.name!=?<sql:param value="${status}"/>
    order by ASH.id desc limit 1;
</sql:query>

<c:if test="${'stopped' == status || 'paused' == status}">
    <ta:setActivityStatus activityId="${activityId}" status="${lastStatusQ.rows[0].name}"/>

    <sql:query var="childrenQ">
select
    A.id 
from
    Activity A
    inner join ActivityStatusHistory ASH on ASH.activityId=A.id and ASH.id=(select max(id) from ActivityStatusHistory where activityId=A.id)
    inner join ActivityFinalStatus AFS on AFS.id=ASH.activityStatusId
where 
    A.parentActivityId=?<sql:param value="${activityId}"/>
    and AFS.id in (select id from ActivityFinalStatus where name in ('stopped', 'paused'))
;
    </sql:query>

    <c:forEach var="childRow" items="${childrenQ.rows}">
        <ta:resumeActivity activityId="${childRow.id}"/>
    </c:forEach>
</c:if>
