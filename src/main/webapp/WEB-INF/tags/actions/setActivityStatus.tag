<%-- 
    Document   : setActivityStatus
    Created on : Apr 6, 2015, 4:06:17 PM
    Author     : focke
--%>

<%@tag description="Change the Status of an Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="status" required="true"%>

    <sql:query var="statusIdQ">
select * from ActivityFinalStatus where name=?<sql:param value="${status}"/>;
    </sql:query>
<c:set var="activityStatus" value="${statusIdQ.rows[0]}"/>
<c:set var="statusId" value="${activityStatus.id}"/>
<c:set var="isFinal" value="${activityStatus.isFinal}"/>

<traveler:getActivityStatus var="oldStatus" varFinal="isOldFinal" activityId="${activityId}"/>

<c:if test="${isOldFinal}">
    <traveler:error message="Can't change status of activity ${activityId} in final state ${oldState}"/>
</c:if>

<c:if test="${status != oldStatus}">

    <c:if test="${isFinal}">
        <sql:query var="childrenQ">
select A.id
from Activity A
inner join ActivityStatusHistory ASH on ASH.activityId=A.id and ASH.id=(select max(id) from ActivityStatusHistory where activityId=A.id)
inner join ActivityFinalStatus AFS on AFS.id=ASH.activityStatusId
where A.parentActivityId=?<sql:param value="${activityId}"/>
and not AFS.isFinal;
        </sql:query>
        <c:forEach var="child" items="${childrenQ.rows}">
            <ta:setActivityStatus activityId="${child.id}" status="${status}"/>
        </c:forEach>
    </c:if>

        <sql:query var="activityQ">
select * from Activity where id=?<sql:param value="${activityId}"/>;
        </sql:query>
    <c:set var="activity" value="${activityQ.rows[0]}"/>
    <c:set var="started" value="${! empty activity.begin}"/>

    <c:if test="${(isFinal && ! started) || (oldStatus == 'new' && status == 'inProgress')}">
        <sql:update>
update Activity set
begin=utc_timestamp()
where id=?<sql:param value="${activityId}"/>;
        </sql:update>
    </c:if>

    <c:if test="${isFinal}">
        <sql:update>
update Activity set
end=utc_timestamp(),
closedBy=?<sql:param value="${userName}"/>
where id=?<sql:param value="${activityId}"/>;
        </sql:update>
    </c:if>

        <sql:update>
insert into ActivityStatusHistory set
activityStatusId=?<sql:param value="${statusId}"/>,
activityId=?<sql:param value="${activityId}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=utc_timestamp();
        </sql:update>

</c:if>
