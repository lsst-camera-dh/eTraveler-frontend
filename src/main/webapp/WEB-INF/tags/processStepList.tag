<%-- 
    Document   : processStepList
    Created on : Jul 24, 2014, 11:42:55 AM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="processId" required="true"%>

<%
    java.util.List stepList = new java.util.LinkedList();
    request.setAttribute("stepList", stepList);
%>

<sql:query var="processQ">
    select P.id as processId, P.name, P.substeps, P.id as processPath,
    null as child
    from Process P
    where id=?<sql:param value="${processId}"/>;
</sql:query>
<c:set var="cRowJsp" value="${processQ.rows[0]}" scope="request"/>
<%
    ((java.util.List)request.getAttribute("stepList")).add(request.getAttribute("cRowJsp"));
%>
<traveler:processStepListRows processId="${processId}" processPrefix="${processId}"/>