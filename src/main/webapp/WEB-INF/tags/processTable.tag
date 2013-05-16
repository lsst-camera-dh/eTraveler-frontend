<%-- 
    Document   : processTable
    Created on : Mar 27, 2013, 12:28:50 PM
    Author     : focke
--%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@tag description="A table showing a process and all its children" pageEncoding="US-ASCII"%>

<%@attribute name="processPath" required="true"%>

<sql:query var="meQ" dataSource="jdbc/rd-lsst-cam">
    select * from Process where id=?<sql:param value="${processId}"/>;
</sql:query>
<table border="1">
    <tr>
        <th>Step</th>
        <th>Name</th>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td>${meQ.rows[0].name}</td>
    </tr>
    <traveler:processRows parentId="${processId}" processPath="${processPath}"/> 
</table>
