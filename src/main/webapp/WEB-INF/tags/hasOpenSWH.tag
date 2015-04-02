<%-- 
    Document   : hasOpenSWH
    Created on : Apr 1, 2015, 7:21:07 PM
    Author     : focke
--%>

<%@tag description="Does an Activity have an unresolved StopWorkHistory record?" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%@attribute name="activityId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="hasOpenSWH" scope="AT_BEGIN"%>

<sql:query var="swhQ">
    select id from StopWorkHistory where activityId=?<sql:param value="${activityId}"/> and resolutionTS is null;
</sql:query>

<c:set var="hasOpenSWH" value="${! empty shwQ.rows}"/>
