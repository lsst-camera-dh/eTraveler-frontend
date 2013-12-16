<%-- 
    Document   : processCrumbs
    Created on : Apr 2, 2013, 2:39:23 PM
    Author     : focke
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%@tag description="Leave a trail of links so you can find parent processes." pageEncoding="US-ASCII"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="processPath" required="true"%>

<table>
    <tr>
        <c:forTokens items="${processPath}" delims="." var="processId" varStatus="status">
            <sql:query var="processNameQ" >
                select concat(name, ' v', version) as processName from Process where id=?<sql:param value="${processId}"/>;
            </sql:query>
            <c:if test="${status.first}">
                <c:set var="myProcessPath" value="${processId}"/>
            </c:if>
            <c:if test="${! status.first}">
                <c:set var="myProcessPath" value="${myProcessPath}.${processId}"/>
            </c:if>
            <c:url value="displayProcess.jsp" var="procLink">
                <c:param name="processPath" value="${myProcessPath}"/>
            </c:url>
            <td><a href="${procLink}">${processNameQ.rows[0].processName}</a> <c:if test="${not status.last}">/</c:if> </td>
        </c:forTokens>
    </tr>
</table>