<%-- 
    Document   : setActivityStatus
    Created on : Apr 6, 2015, 4:06:17 PM
    Author     : focke
--%>

<%@tag description="Change the Status of an Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="status" required="true"%>

    <sql:query var="statusIdQ">
select * from ActivityFinalStatus where name=?<sql:param value="${status}"/>;
    </sql:query>
<c:set var="activityStatus" value="${statusIdQ.rows[0]}"/>
<c:set var="statusId" value="${activityStatus.id}"/>
<c:set var="isFinal" value="${activityStatus.isFinal}"/>

    <sql:query var="activityQ">
select * from Activity where id=?<sql:param value="${activityId}"/>;
    </sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>
<c:set var="started" value="${! empty activity.begin}"/>

    <sql:update>
update Activity set 
<c:if test="${isFinal}">
    <c:if test="${! started}">begin=utc_timestamp(),</c:if>
    end=utc_timestamp(),
    closedBy=?<sql:param value="${userName}"/>,
</c:if>
activityFinalStatusId=?<sql:param value="${statusId}"/> 
where id=?<sql:param value="${activityId}"/>;
    </sql:update>

    <sql:update>
insert into ActivityStatusHistory set
activityStatusId=?<sql:param value="${statusId}"/>,
activityId=?<sql:param value="${activityId}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=utc_timestamp();
    </sql:update>
