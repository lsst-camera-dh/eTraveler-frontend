<%-- 
    Document   : setPaths
    Created on : Apr 8, 2013, 4:17:31 PM
    Author     : focke
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@tag description="put the tag description here" pageEncoding="US-ASCII"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>

<sql:query var="activityQ" dataSource="jdbc/rd-lsst-cam">
    select * from Activity where id=?<sql:param value="${activityId}"/>;
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<c:choose>
    <c:when test="${! empty activity.parentActivityId}">
        <traveler:setPaths activityId="${activity.parentActivityId}"/>
        <c:set var="processPath" value="${processPath}.${activity.processId}" scope="request"/>
        <c:set var="activityPath" value="${activityPath}.${activityId}" scope="request"/>
    </c:when>
    <c:otherwise>
        <c:set var="processPath" value="${activity.processId}" scope="request"/>
        <c:set var="activityPath" value="${activityId}" scope="request"/>        
    </c:otherwise>
</c:choose>
    