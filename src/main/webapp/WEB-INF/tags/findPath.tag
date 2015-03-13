<%-- 
    Document   : findPath
    Created on : Apr 18, 2014, 2:14:56 PM
    Author     : focke
--%>

<%@tag description="Find the edgePath to reach an Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="edgePath" scope="AT_BEGIN"%>

<sql:query var="activityQ">
    select * from Activity where id=?<sql:param value="${activityId}"/>;
</sql:query>

<c:if test="${! empty activityQ.rows[0].parentActivityId}">
    <traveler:findPath var="parentEdgePath" activityId="${activityQ.rows[0].parentActivityId}"/>
</c:if>

<traveler:dotOrNot var="prefix" prefix="${parentEdgePath}"/>
<c:set var="edgePath" value="${prefix}${activityQ.rows[0].processEdgeId}"/>
