<%-- 
    Document   : expandProcess
    Created on : Jul 24, 2014, 11:42:55 AM
    Author     : focke
--%>

<%@tag description="Make a list of the steps in a traveler type" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="processId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="stepList" scope="AT_BEGIN"%>

<%
    java.util.List stepList = new java.util.LinkedList();
    jspContext.setAttribute("stepList", stepList);
%>

<sql:query var="theQ">
    select P.id as processId, P.name, P.substeps, P.id as processPath, P.shortDescription
    from Process P
    where P.id=?<sql:param value="${processId}"/>;
</sql:query>
<c:set var="cRow" value="${theQ.rows[0]}"/>

<%
    stepList.add(jspContext.getAttribute("cRow"));
%>

<traveler:expandProcessRows
    processId="${processId}"
    stepList="${stepList}"
    processPrefix="${cRow.processId}"/>
