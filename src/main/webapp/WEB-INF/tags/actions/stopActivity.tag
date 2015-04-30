<%-- 
    Document   : stopActivity
    Created on : Apr 23, 2014, 1:54:00 PM
    Author     : focke
--%>

<%@tag description="Stop Work on an Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="status"%>

<c:if test="${empty status}">
    <c:set var="status" value="stopped"/>
</c:if>

<ta:setActivityStatus activityId="${activityId}" status="${status}"/>

<sql:query var="childrenQ">
    select id 
    from Activity 
    where parentActivityId=?<sql:param value="${activityId}"/>
    and end is null;
</sql:query>

<c:forEach var="child" items="${childrenQ.rows}">
    <ta:stopActivity activityId="${child.id}" status="${status}"/>
</c:forEach>
