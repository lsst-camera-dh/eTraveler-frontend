<%-- 
    Document   : processRows
    Created on : Mar 25, 2013, 1:55:30 PM
    Author     : focke
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@tag description="This expands the children for processTable" pageEncoding="US-ASCII"%>

<%@attribute name="parentId" required="true"%>
<%@attribute name="prefix"%>
<%@attribute name="processPath" required="true"%>
<%@attribute name="emptyFields"%>

<sql:query var="childrenQ" dataSource="jdbc/rd-lsst-cam">
    select 
    PE.child, PE.step, P.name, P.id 
    from ProcessEdge PE, Process P
    where PE.parent=?<sql:param value="${parentId}"/>
    and
    PE.child=P.id
    order by PE.step;
</sql:query>

<c:if test="${! empty prefix}">
    <c:set var="prefixDot" value="${prefix}."/>
</c:if>
    
<c:forEach var="row" items="${childrenQ.rows}">
    <c:set var="hierStep" value="${prefixDot}${row.step}"/>
    <c:set var="myProcessPath" value="${processPath}.${row.child}"/>
    <c:url value="displayProcess.jsp" var="childLink">
        <c:param name="processPath" value="${myProcessPath}"/>
    </c:url>
    <tr>
        <td><a href="${childLink}">${hierStep}</a></td>
        <td>${row.name}</td>
        <c:if test="${! empty emptyFields}"> <%-- Find a way to do this with a loop --%>
            <td></td> <td></td>
        </c:if>
    </tr>
    <traveler:processRows parentId="${row.child}" prefix="${hierStep}" processPath="${myProcessPath}" emptyFields="${emptyFields}"/>
</c:forEach>
