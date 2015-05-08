<%-- 
    Document   : activityStatusWidget
    Created on : Apr 15, 2015, 5:59:01 PM
    Author     : focke
--%>

<%@tag description="Display stuff about an Activity's status" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>

<%@attribute name="activityId" required="true"%>

    <sql:query var="statusQ">
select
    ASH.createdBy, ASH.creationTS,
    AFS.name
from
    ActivityStatusHistory ASH
    inner join ActivityFinalStatus AFS on AFS.id=ASH.activityStatusId
where
    ASH.activityId=?<sql:param value="${activityId}"/>
order by 
    ASH.id desc
;
    </sql:query>
<h3>Status History</h3>
<display:table name="${statusQ.rows}" class="datatable" sort="list"
               pagesize="${fn:length(result.rows) > preferences.pageLength ? preferences.pageLength : 0}">
    <display:column property="name" title="Status" sortable="true" headerClass="sortable"/>
    <display:column property="createdBy" title="Who" sortable="true" headerClass="sortable"/>
    <display:column property="creationTS" title="When" sortable="true" headerClass="sortable"/>
</display:table>