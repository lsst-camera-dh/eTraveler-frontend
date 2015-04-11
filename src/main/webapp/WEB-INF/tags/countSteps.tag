<%-- 
    Document   : countSteps
    Created on : Apr 10, 2015, 4:56:40 PM
    Author     : focke
--%>

<%@tag description="Count the steps in a process and its children" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="processId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="nSteps" scope="AT_BEGIN"%>

<c:set var="nSteps" value="1"/>

<sql:query var="childrenQ" >
    select 
    PE.child
    from ProcessEdge PE
    where PE.parent=?<sql:param value="${processId}"/>
    ;
</sql:query>

<c:forEach var="cRow" items="${childrenQ.rows}">
    <traveler:countSteps var="cSteps" processId="${cRow.child}"/>
    <c:set var="nSteps" value="${nSteps + cSteps}"/>
</c:forEach>
