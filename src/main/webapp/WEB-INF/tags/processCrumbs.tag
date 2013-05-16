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
            <sql:query var="processNameQ" dataSource="jdbc/rd-lsst-cam">
                select name, version from Process where id=?<sql:param value="${processId}"/>;
            </sql:query>
            <c:set var="processName" value="${processNameQ.rows[0]}"/>
            <c:set var="nameAndVersion" value="${processName.name} v${processName.version}"/>
            <c:if test="${status.first}">
                <c:set var="myProcessPath" value="${processId}"/>
            </c:if>
<%--            <c:choose>
                <c:when test="${status.last}">
                    <td>${nameAndVersion}</td>
                </c:when>
                <c:otherwise>--%>
                    <c:if test="${! status.first}">
                        <c:set var="myProcessPath" value="${myProcessPath}.${processId}"/>
                    </c:if>
                    <c:url value="displayProcess.jsp" var="procLink">
                        <c:param name="processPath" value="${myProcessPath}"/>
                    </c:url>
<td><a href="${procLink}">${nameAndVersion}</a> <c:if test="${not status.last}">/</c:if> </td>
<%--                </c:otherwise>
            </c:choose>--%>
        </c:forTokens>
    </tr>
</table>