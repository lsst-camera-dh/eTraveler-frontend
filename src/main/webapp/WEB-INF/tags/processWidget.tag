<%-- 
    Document   : processWidget
    Created on : May 17, 2013, 11:01:58 AM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="processId" required="true"%>
<%@attribute name="parentActivityId"%>
<%@attribute name="processEdgeId"%>

<sql:query var="processQ" dataSource="jdbc/rd-lsst-cam">
    select * from Process where id=?<sql:param value="${processId}"/>;
</sql:query>
<c:set var="process" value="${processQ.rows[0]}"/>
<%--
<h2>
    <c:out value="${process.name}"/> v<c:out value="${process.version}"/>
</h2>
--%>
<c:if test="${! empty process.description}">
    <c:out value="${process.description}"/>
    <br>
</c:if>
<c:if test="${! empty process.instructionsURL}">
    <a href="${process.instructionsURL}">Detailed Instructions</a>
</c:if>
<c:if test="${empty param.activityId}">
    <traveler:processPrereqWidget processId="${processId}"/>
</c:if>
    
