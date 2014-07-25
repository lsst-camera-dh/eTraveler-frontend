<%-- 
    Document   : processStepListRows
    Created on : Jul 24, 2014, 11:43:14 AM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="processId" required="true"%>

<sql:query var="childrenQ" >
    select 
    PE.child, PE.step, P.name, P.id, P.substeps
    from ProcessEdge PE
    inner join Process P on P.id=PE.child
    where PE.parent=?<sql:param value="${processId}"/>
    order by abs(PE.step);
</sql:query>

<c:forEach var="cRow" items="${childrenQ.rows}">
    <c:set var="cRowJsp" value="${cRow}" scope="request"/>
    <%
        ((java.util.List)request.getAttribute("stepList")).add(request.getAttribute("cRowJsp"));
    %>
    <traveler:processStepListRows processId="${cRow.child}"/>
</c:forEach>