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
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="theList" scope="AT_BEGIN"%>

<c:if test="${mode != 'activity' && mode != 'process'}">
    <%-- Should redirect to an error page here --%>
    Programmer error #358987
</c:if>

<%
    java.util.List theList = new java.util.LinkedList();
    jspContext.setAttribute("theList", theList);
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
<c:set var="cRow" value="${theQ.rows[0]}"/>
<%
    ((java.util.List)jspContext.getAttribute("theList")).add(jspContext.getAttribute("cRow"));
%>
<traveler:stepListRows theId="${theId}" theList="${theList}" mode="${mode}" processPrefix="${theQ.rows[0].processId}"/>
