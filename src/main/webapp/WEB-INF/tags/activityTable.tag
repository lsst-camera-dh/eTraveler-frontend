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

<sql:query var="activityQ" >
    select A.begin, A.end, P.name, P.id as processId, P.substeps,
    AFS.name as statusName
    from Activity A
    inner join Process P on P.id=A.processId
    left join ActivityFinalStatus AFS on AFS.id=A.activityFinalStatusId
    where A.id=?<sql:param value="${activityId}"/>;
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<c:set var="travelerFailed" 
       value="${activity.statusName=='failure' || activity.statusName=='stopped'}" scope="request"/>

<c:url var="contentLink" value="activityPane.jsp">
    <c:param name="activityId" value="${activityId}"/>
    <c:param name="topActivityId" value="${activityId}"/>
</c:url>
<c:set var="currentStepLink" value="${contentLink}" scope="request"/>

<table border="1">
    <tr> <th>Step</th> <th>Name</th> <th>Begin</th> <th>End</th> </tr>
    <tr>
        <td></td>
        <td><a href="${contentLink}" target="content">${activity.name}</a></td>
        <td>
            <c:choose>
                <c:when test="${empty activity.begin}">
                    In Prep
                </c:when>
                <c:otherwise>
                    ${activity.begin}
                </c:otherwise>
            </c:choose>
        </td>
        <td>
            <%--<traveler:closeoutButton activityId="${activityId}"/>--%>
            <c:choose>
                <c:when test="${empty activity.end}">
                    In Progress
                </c:when>
                <c:otherwise>
                    ${activity.statusName} ${activity.end}
                </c:otherwise>
            </c:choose>
        </td>
    </tr>

    <c:choose>
        <c:when test="${empty activity.begin && activity.substeps != 'NONE'}">
            <traveler:processRows parentId="${activity.processId}" processPath="${activity.processId}" emptyFields="true"/>
        </c:when>
        <c:when test="${activity.substeps == 'SEQUENCE'}">
            <traveler:activityRowsFull activityId="${activityId}"/>
        </c:when>
        <c:when test="${activity.substeps == 'SELECTION'}">
            <traveler:selectionRows activityId="${activityId}"/>
        </c:when>
    </c:choose>
    
</table>