<%-- 
    Document   : setPaths
    Created on : Apr 8, 2013, 4:17:31 PM
    Author     : focke
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@tag description="set process and activity paths to reach an Activity" pageEncoding="US-ASCII"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="activityVar" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="activityVar" alias="activityPath" scope="AT_BEGIN"%>
<%@attribute name="processVar" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="processVar" alias="processPath" scope="AT_BEGIN"%>

<sql:query var="activityQ" >
    select * from Activity where id=?<sql:param value="${activityId}"/>;
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<c:choose>
    <c:when test="${! empty activity.parentActivityId}">
        <traveler:setPaths activityVar="paPath" processVar="ppPath" activityId="${activity.parentActivityId}"/>
        <c:set var="processPath" value="${ppPath}.${activity.processId}"/>
        <c:set var="activityPath" value="${paPath}.${activityId}"/>
    </c:when>
    <c:otherwise>
        <c:set var="processPath" value="${activity.processId}"/>
        <c:set var="activityPath" value="${activityId}"/>        
    </c:otherwise>
</c:choose>
    