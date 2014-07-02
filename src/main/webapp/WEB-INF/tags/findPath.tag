<%-- 
    Document   : findTraveler
    Created on : Apr 18, 2014, 2:14:56 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="edgePath" scope="AT_BEGIN"%>

<sql:query var="activityQ">
    select * from Activity where id=?<sql:param value="${activityId}"/>;
</sql:query>

<c:if test="${! empty activityQ.rows[0].parentActivityId}">
    <traveler:findPath var="parentEdgePath" activityId="${activityQ.rows[0].parentActivityId}"/>
</c:if>

<%--<c:set var="prefix" value="${empty parentEdgePath ? '' : parentEdgePath.toString() + ','}"/>--%>
<c:if test="${! empty parentEdgePath}">
    <c:set var="prefix" value="${parentEdgePath},"/>
</c:if>
<c:set var="edgePath" value="${prefix}${activityQ.rows[0].processEdgeId}"/>
