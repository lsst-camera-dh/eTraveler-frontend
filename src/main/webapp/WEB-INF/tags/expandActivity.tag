<%-- 
    Document   : expandActivity
    Created on : Sep 25, 2014, 3:19:36 PM
    Author     : focke
--%>

<%@tag description="List all substeps of an activity, done or not, including NCRs" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="outList" scope="AT_BEGIN"%>

<%
    java.util.List outList = new java.util.LinkedList();
    jspContext.setAttribute("outList", outList);
%>

<%-- Once a selection has been made, the unchosen substeps no longer show up in the list. This is intentional.
     Unless they are at the end of the list. This is not. --%>

<sql:query var="processQ">
    select processId from Activity where id=?<sql:param value="${activityId}"/>
</sql:query>
<traveler:expandProcess processId="${processQ.rows[0].processId}" var="processSteps"/>
<traveler:childActivities activityId="${activityId}" varAc="acList" varEx="exList"/>

<c:set var="lastException" value="0"/>
<c:forEach items="${exList}" var="exceptionId">
    <sql:query var="exceptionQ">
select
    E.id as exceptionId, E.*,
    ET.*
from
    Exception E
    inner join ExceptionType ET on ET.id=E.exceptionTypeId
where
    E.id=?<sql:param value="${exceptionId}"/>;
    </sql:query>
    <c:set var="exRow" value="${exceptionQ.rows[0]}"/>
        
    <c:set var="thisException" value="${exRow.NCRActivityId}"/>
    <c:set var="returnEdgePath" value="${exRow.returnProcessPath}"/>
    
    <c:forEach items="${acList}" var="acRow">
        <c:if test="${acRow.activityId > lastException && acRow.activityId < thisException}">
<%
    outList.add(jspContext.getAttribute("acRow"));
%>
        </c:if>
    </c:forEach>
    <traveler:expandActivity activityId="${thisException}" var="exChildren"/>
<%
    outList.addAll((java.util.List)jspContext.getAttribute("exChildren"));
%>
    
    <c:set var="lastException" value="${thisException}"/>
</c:forEach>

<c:set var="trailingActivities" value="false"/>
<c:forEach items="${acList}" var="acRow">
    <c:if test="${acRow.activityId > lastException}">
        <c:set var="trailingActivities" value="true"/>
<%
    outList.add(jspContext.getAttribute("acRow"));
%>
    </c:if>
</c:forEach>

<%-- This is wrong if we are currently in an exception and returnPath != exitPath.
     Then we have to use returnEdgePath somehow. --%>
<c:set var="lastEdgePath" value="${acList[fn:length(acList)-1].edgePath}"/> <%-- NO! --%>
<c:set var="appending" value="false"/>
<c:forEach items="${processSteps}" var="pRow">
    <c:if test="${! trailingActivities && pRow.edgePath == returnEdgePath}">
        <c:set var="appending" value="true"/>
    </c:if>
    <c:choose>
        <c:when test="${appending}">
<%
    outList.add(jspContext.getAttribute("pRow"));
%>            
        </c:when>
        <c:when test="${trailingActivities && pRow.edgePath == lastEdgePath}">
            <c:set var="appending" value="true"/>
        </c:when>
    </c:choose>
</c:forEach>