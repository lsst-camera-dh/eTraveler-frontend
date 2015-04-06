<%-- 
    Document   : resumeActivity
    Created on : Apr 17, 2014, 3:53:34 PM
    Author     : focke
--%>

<%@tag description="Resume work on a stopped traveler." pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="activityId" required="true"%>

<sql:query var="activityQ">
    select * from Activity where id=?<sql:param value="${activityId}"/>
</sql:query>
<c:set var="neverStarted" value="${activityQ.rows[0].begin == activityQ.rows[0].end}"/>

<sql:update>
    update Activity set
    <c:if test="${neverStarted}">begin=null,</c:if>
    activityFinalStatusId=null, end=null, closedBy=null
    where id=?<sql:param value="${activityId}"/>
</sql:update>

<sql:query var="childrenQ">
    select  id from Activity where 
    parentActivityId=?<sql:param value="${activityId}"/>
    and activityFinalStatusId=(select id from ActivityFinalStatus where name='stopped')
</sql:query>

<c:forEach var="childRow" items="${childrenQ.rows}">
    <ta:resumeActivity activityId="${childRow.id}"/>
</c:forEach>
