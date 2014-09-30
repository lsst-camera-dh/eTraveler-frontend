<%-- 
    Document   : childActivities
    Created on : Jul 24, 2014, 11:42:55 AM
    Author     : focke
--%>

<%@tag description="Make a lists of the steps in an activity and any exceptions" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="varAc" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="varAc" alias="acList" scope="AT_BEGIN"%>
<%@attribute name="varEx" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="varEx" alias="exList" scope="AT_BEGIN"%>

<%
    java.util.List acList = new java.util.LinkedList();
    jspContext.setAttribute("acList", acList);
    java.util.List exList = new java.util.LinkedList();
    jspContext.setAttribute("exList", exList);
%>

<sql:query var="theQ">
    select 
        A.id as activityId, A.begin, A.end, A.hardwareId, A.inNCR,
        P.name, P.id as processId, P.substeps, P.id as processPath,
        AFS.name as statusName,
        E.id as exceptionId
    from 
        Activity A
        inner join Process P on P.id=A.processId
        left join ActivityFinalStatus AFS on AFS.id=A.activityFinalStatusId
        left join Exception E on E.exitActivityId=A.id
    where 
        A.id=?<sql:param value="${activityId}"/>
    ;
</sql:query>
<c:set var="cRow" value="${theQ.rows[0]}"/>
<%
    acList.add(jspContext.getAttribute("cRow"));
%>
<c:set var="exceptionId" value="${cRow.exceptionId}"/>
<c:if test="${! empty exceptionId}">
<%
    exList.add(jspContext.getAttribute("exceptionId"));
%>    
</c:if>

<traveler:childActivitiesRows 
    activityId="${activityId}" 
    acList="${acList}" 
    exList="${exList}" 
    processPrefix="${theQ.rows[0].processId}"/>

<%
    java.util.Collections.sort(exList);
%>
