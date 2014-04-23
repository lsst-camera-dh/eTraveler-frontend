<%-- 
    Document   : stopActivity
    Created on : Apr 23, 2014, 1:54:00 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>
<%@attribute name="status"%>

<c:if test="${empty status}">
    <c:set var="status" value="stopped"/>
</c:if>

<sql:query var="activityQ">
    select *
    from Activity
    where id=?<sql:param value="${activityId}"/>
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<sql:update>
    update Activity set
    activityFinalStatusId=(select id from ActivityFinalStatus where name=?<sql:param value="${status}"/>),
    <c:if test="${empty activity.begin}">begin=now(),</c:if>
    end=now(),
    closedBy=?<sql:param value="${userName}"/>
    where id=?<sql:param value="${activityId}"/>;    
</sql:update>

<sql:query var="childrenQ">
    select id 
    from Activity 
    where parentActivityId=?<sql:param value="${activityId}"/>
    and end is null;
</sql:query>

<c:forEach var="child" items="${childrenQ.rows}">
    <ta:stopActivity activityId="${child.id}"/>
</c:forEach>
