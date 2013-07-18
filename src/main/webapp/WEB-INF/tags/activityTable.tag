<%-- 
    Document   : activityTable
    Created on : Apr 15, 2013, 10:38:36 AM
    Author     : focke
--%>

<%@tag description="A table showing an activity and its child activities and processes" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>

<sql:query var="activityQ" dataSource="jdbc/rd-lsst-cam">
    select A.begin, A.end, P.name
    from Activity A, Process P where
    P.id=A.processId and
    A.id=?<sql:param value="${activityId}"/>;
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<c:url var="contentLink" value="activityPane.jsp">
    <c:param name="activityId" value="${activityId}"/>
</c:url>

<table border="1">
    <tr> <th>Step</th> <th>Name</th> <th>Begin</th> <th>End</th> </tr>
    <tr>
        <td></td>
        <td><a href="${contentLink}" target="content">${activity.name}</a></td>
        <td>${activity.begin}</td>
        <td><%--<traveler:closeoutButton activityId="${activityId}"/>--%>${activity.end}</td>
    </tr>

    <traveler:activityRowsFull activityId="${activityId}"/>
    
</table>