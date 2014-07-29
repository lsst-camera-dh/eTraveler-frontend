<%-- 
    Document   : stepList
    Created on : Jul 24, 2014, 11:42:55 AM
    Author     : focke
--%>

<%@tag description="Make a list of the steps in a traveler or traveler type" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="theId" required="true"%>
<%@attribute name="mode" required="true"%>

<c:if test="${mode != 'activity' && mode != 'process'}">
    <%-- Should redirect to an error page here --%>
    Programmer error #358987
</c:if>

<%
    java.util.List stepList = new java.util.LinkedList();
    request.setAttribute("stepList", stepList);
%>

<sql:query var="theQ">
    <c:choose>
        <c:when test="${mode == 'activity'}">
select A.id as activityId, A.begin, A.end, 
P.name, P.id as processId, P.substeps, P.id as processPath,
AFS.name as statusName
from Activity A
inner join Process P on P.id=A.processId
left join ActivityFinalStatus AFS on AFS.id=A.activityFinalStatusId
where A.id=?<sql:param value="${theId}"/>;
        </c:when>
        <c:when test="${mode == 'process'}">
select P.id as processId, P.name, P.substeps, P.id as processPath
from Process P
where P.id=?<sql:param value="${theId}"/>;
        </c:when>
        <c:otherwise>
arglebargle #358987
        </c:otherwise>
    </c:choose>
</sql:query>
<c:set var="cRowJsp" value="${theQ.rows[0]}" scope="request"/>
<%
    ((java.util.List)request.getAttribute("stepList")).add(request.getAttribute("cRowJsp"));
%>
<traveler:stepListRows theId="${theId}" mode="${mode}" processPrefix="${theQ.rows[0].processId}"/>
