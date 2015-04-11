<%-- 
    Document   : skipStep
    Created on : Apr 8, 2015, 2:34:34 PM
    Author     : focke
--%>

<%@tag description="Skip a step" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="activityId" required="true"%>

${activityId}

<sql:query var="childrenQ">
    select id from Activity 
    where parentActivityId=?<sql:param value="${activityId}"/>
    and end is null;
</sql:query>
    
<c:forEach var="child" items="${childrenQ.rows}">
    <ta:skipStep activityId="${child.id}"/>
</c:forEach>