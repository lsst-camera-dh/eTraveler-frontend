<%-- 
    Document   : closeoutButton
    Created on : Apr 11, 2013, 12:06:18 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>

<sql:query var="activityQ" dataSource="jdbc/rd-lsst-cam">
    select * from Activity where id=?<sql:param value="${activityId}"/>;
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<c:choose>
    <c:when test="${empty activity.end}">
        <sql:query var="stepsRemainingQ" dataSource="jdbc/rd-lsst-cam">
            select (
                (select count(*) from ProcessEdge where parent=?<sql:param value="${activity.processId}"/>) 
                -
                (select count(*) from Activity where 
                parentActivityId=?<sql:param value="${activityId}"/>
                and 
                end is not null) 
            ) stepsRemaining from dual;
        </sql:query>
        <c:choose>
            <c:when test="${stepsRemainingQ.rows[0]['stepsRemaining']==0}">
                <form METHOD=GET ACTION="closeoutActivity.jsp">
                    <input type="hidden" name="activityId" value="${activityId}">       
                    <INPUT TYPE=SUBMIT value="Closeout">
                </form>
            </c:when>
            <c:otherwise>
                <c:url var="activityLink" value="displayActivity.jsp">
                    <c:param name="activityId" value="${activityId}"/>
                </c:url>
<%--                <a href="${activityLink}">Needs work</a>--%>
                Needs Work
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
<%--        Closed out at ${activity.rows[0]['end']} by <c:out value="${activity.rows[0]['closedBy']}"/>--%>
        <c:out value="${activity.end}"/>
    </c:otherwise>
</c:choose>