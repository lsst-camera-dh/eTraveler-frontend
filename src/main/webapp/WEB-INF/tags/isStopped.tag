<%-- 
    Document   : isStopped
    Created on : Apr 18, 2014, 2:58:44 PM
    Author     : focke
--%>

<%@tag description="Figure out if an Activity is in Stop Work" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="isStopped" scope="AT_BEGIN"%>

<sql:query var="activityQ">
    select AFS.name
    from Activity A
    inner join ActivityStatusHistory ASH on ASH.activityId=A.id and ASH.id=(select max(id) from ActivityStatusHistory where activityId=A.id)
    inner join ActivityFinalStatus AFS on AFS.id=ASH.activityStatusId
    where A.id=?<sql:param value="${activityId}"/>;
</sql:query>

<c:set var="isStopped" value="${empty activityQ.rows ? false : 'stopped' == activityQ.rows[0].name}"/>
