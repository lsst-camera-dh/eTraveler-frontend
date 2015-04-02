<%-- 
    Document   : activityStopWidget
    Created on : Mar 26, 2015, 10:37:00 AM
    Author     : focke
--%>

<%@tag description="Display info about work stoppages for an Activity" pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>

<sql:query var="swQ">
    select SWH.*,
    EI.NCRActivityId, ET.conditionString
    from StopWorkHistory SWH
    left join Exception EI on EI.exitActivityId=SWH.activityId
    left join ExceptionType ET on ET.id=EI.exceptionTypeId
    where SWH.activityId=?<sql:param value="${activityId}"/>
    order by SWH.id desc
    ;
</sql:query>

    <c:choose>
        <c:when test="${! empty swQ.rows}">
            <h3>Work Stoppages</h3>
<display:table name="${swQ.rows}" id="row" class="datatable" pagesize="${preferences.pageLength}" sort="list">
    <display:column property="reason" sortable="true" headerClass="sortable"/>
    <display:column property="createdBy" title="Stopped By" sortable="true" headerClass="sortable"/>
    <display:column property="creationTS" title="Stop Time" sortable="true" headerClass="sortable"/>
    <display:column title="NCR?" sortable="true" headerClass="sortable">
        <c:url var="ncrLink" value="displayActivity.jsp">
            <c:param name="activityId" value="${row.NCRActivityId}"/>
        </c:url>
        <a href="${ncrLink}" target="_top">${row.conditionString}</a>        
    </display:column>
    <display:column property="resolution" sortable="true" headerClass="sortable"/>
    <display:column property="resolvedBy" title="Resolved By" sortable="true" headerClass="sortable"/>
    <display:column property="resolutionTs" title="Resolution Time" sortable="true" headerClass="sortable"/>
</display:table>
        </c:when>
        <c:otherwise>
            <h3>No Work Stoppages</h3>
        </c:otherwise>
    </c:choose>
