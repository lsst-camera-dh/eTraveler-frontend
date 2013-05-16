<%-- 
    Document   : activityCrumbs
    Created on : Apr 28, 2013, 
    Author     : focke
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%@tag description="Leave a trail of links so you can find parent activities." pageEncoding="US-ASCII"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityPath" required="true"%>

<table>
    <tr>
        <c:forTokens items="${activityPath}" delims="." var="activityId" varStatus="status">
            <sql:query var="processNameQ" dataSource="jdbc/rd-lsst-cam">
                select P.name, P.version 
                from Process P, Activity A 
                where P.id=A.processId and A.id=?<sql:param value="${activityId}"/>;
            </sql:query>
            <c:set var="processName" value="${processNameQ.rows[0]}"/>
            <c:set var="nameAndVersion" value="${processName.name} v${processName.version}"/>
<%--            <c:choose>
                <c:when test="${status.last}">
                    <td>${nameAndVersion}</td>
                </c:when>
                <c:otherwise>--%>
                    <c:url value="displayActivity.jsp" var="actLink">
                        <c:param name="activityId" value="${activityId}"/>
                    </c:url>
<td><a href="${actLink}">${nameAndVersion}</a> <c:if test="${not status.last}">/</c:if> </td>
<%--                </c:otherwise>
            </c:choose>--%>
        </c:forTokens>
    </tr>
</table>