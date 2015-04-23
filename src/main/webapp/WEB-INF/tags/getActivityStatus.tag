<%-- 
    Document   : getActivityStatus
    Created on : Apr 10, 2015, 5:55:45 PM
    Author     : focke
--%>

<%@tag description="Find the status of an Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="status" scope="AT_BEGIN"%>

<sql:query var="statusQ">
    select 
        AFS.name
    from 
        ActivityFinalStatus AFS
        inner join ActivityStatusHistory ASH on ASH.activityStatusId=AFS.id
    where 
        ASH.activityId=?<sql:param value="${activityId}"/>
    order by
        ASH.id desc limit 1
    ;
</sql:query>
<c:set var="status" value="${statusQ.rows[0].name}"/>
