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
<%@attribute name="activityId" required="true"%>

<%
    java.util.List stepList = new java.util.LinkedList();
    request.setAttribute("stepList", stepList);
%>

<sql:query var="activityQ">
    select A.id as activityId, A.begin, A.end, 
    P.name, P.id as processId, P.substeps, P.id as processPath,
    AFS.name as statusName
    from Activity A
    inner join Process P on P.id=A.processId
    left join ActivityFinalStatus AFS on AFS.id=A.activityFinalStatusId
    where A.id=?<sql:param value="${activityId}"/>;
</sql:query>
<c:set var="cRowJsp" value="${activityQ.rows[0]}" scope="request"/>
<%
    ((java.util.List)request.getAttribute("stepList")).add(request.getAttribute("cRowJsp"));
%>
<traveler:activityStepListRows activityId="${activityId}" processPrefix="${cRowJsp.processId}"/>