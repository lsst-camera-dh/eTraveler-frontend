<%-- 
    Document   : activityCrumbs
    Created on : Apr 28, 2013, 
    Author     : focke
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%@tag description="Leave a trail of links so you can find parent activities." pageEncoding="US-ASCII"%>

<%@attribute name="activityPath" required="true"%>

<table>
    <tr>
        <c:forTokens items="${activityPath}" delims="." var="activityId" varStatus="status">
            <sql:query var="processNameQ" >
                select concat(P.name, ' v', P.version) as processName 
                from Process P, Activity A 
                where P.id=A.processId and A.id=?<sql:param value="${activityId}"/>;
            </sql:query>
            <c:url value="displayActivity.jsp" var="actLink">
                <c:param name="activityId" value="${activityId}"/>
            </c:url>
            <td><a href="${actLink}">${processNameQ.rows[0].processName}</a> <c:if test="${not status.last}">/</c:if> </td>
        </c:forTokens>
    </tr>
</table>