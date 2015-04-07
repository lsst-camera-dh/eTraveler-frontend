<%-- 
    Document   : setActivityStatus
    Created on : Apr 6, 2015, 4:06:17 PM
    Author     : focke
--%>

<%@tag description="Change the Status of an Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%@attribute name="activityId" required="true"%>
<%@attribute name="status" required="true"%>

<sql:transaction>
    <sql:query var="statusIdQ">
select id from ActivityFinalStatus where name=?<sql:param value="${status}"/>;
    </sql:query>
    <c:set var="activityStatusId" value="${statusIdQ.rows[0].id}"/>
    <sql:update>
update Activity set 
activityFinalStatusId=?<sql:param value="${activityStatusId}"/> 
where id=?<sql:param value="${activityId}"/>;
    </sql:update>
    <sql:update>
insert into ActivityStatusHistory set
activityStatusId=?<sql:param value="${activityStatusId}"/>,
activityId=?<sql:param value="${activityId}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=utc_timestamp();
    </sql:update>
</sql:transaction>