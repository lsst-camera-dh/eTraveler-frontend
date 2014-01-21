<%-- 
    Document   : processTable
    Created on : Mar 27, 2013, 12:28:50 PM
    Author     : focke
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@tag description="A table showing a process and all its children" pageEncoding="US-ASCII"%>

<%@attribute name="processPath" required="true"%>

<sql:query var="meQ" >
    select * from Process where id=?<sql:param value="${processId}"/>;
</sql:query>
    <c:url var="contentLink" value="processPane.jsp">
        <c:param name="processId" value="${processId}"/>
    </c:url>
<table border="1">
    <tr>
        <th>Step</th>
        <th>Name</th>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td><a href="${contentLink}" target="content">${meQ.rows[0].name}</a></td>
    </tr>
    <c:if test="${meQ.rows[0].substeps != 'NONE'}">
        <traveler:processRows parentId="${processId}" processPath="${processPath}"/> 
    </c:if>
</table>
