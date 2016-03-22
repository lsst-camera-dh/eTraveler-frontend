<%-- 
    Document   : hardwareStatusWidget
    Created on : Oct 31, 2013, 11:10:46 AM
    Author     : focke
--%>

<%@tag description="Display various stuff about a component's status" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="hardwareId" required="true"%>

<sql:query  var="statusHistoryQ">
    select HS.name as statusName, HSH.*, P.name as processName
    from HardwareStatus HS
    inner join HardwareStatusHistory HSH on HS.id=HSH.hardwareStatusId
    left join (Activity A
    inner join Process P on P.id=A.processId) on A.id=HSH.activityId
    where HSH.hardwareId=?<sql:param value="${hardwareId}"/>
    and HS.isStatusValue=1
    order by HSH.id desc;
</sql:query>
    
<display:table name="${statusHistoryQ.rows}" class="datatable" sort="list"
               pagesize="${fn:length(statusHistoryQ.rows) > preferences.pageLength ? preferences.pageLength : 0}">
    <display:column property="statusName" title="Status" sortable="true" headerClass="sortable"/>
    <display:column property="reason" title="Reason" sortable="true" headerClass="sortable"/>
    <display:column property="processName" title="Step" sortable="true" headerClass="sortable"
                    href="displayActivity.jsp" paramId="activityId" paramProperty="activityId"/>
    <display:column property="creationTS" title="Date" sortable="true" headerClass="sortable"/>
    <display:column property="createdBy" title="User" sortable="true" headerClass="sortable"/>
</display:table>

<traveler:hardwareStatusForm hardwareId="${hardwareId}"/>
