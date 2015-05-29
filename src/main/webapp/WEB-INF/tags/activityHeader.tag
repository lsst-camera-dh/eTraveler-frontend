<%-- 
    Document   : activityHeader
    Created on : Aug 5, 2014, 4:44:36 PM
    Author     : focke
--%>

<%@tag description="Show a little info about an Activity." pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="activityId" required="true"%>

<sql:query var="activityQ" >
    select * from Activity where id=?<sql:param value="${activityId}"/>;
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<table>
    <tr>
        <td>Created:</td><td>${activity.creationTS}</td><td>${activity.createdBy}</td>
    </tr>
    <tr>
        <td>Started:</td><td>${activity.begin}</td><td></td>
    </tr>
    <tr>
        <td>Ended:</td><td>${activity.end}</td><td>${activity.closedBy}</td>
    </tr>
</table>