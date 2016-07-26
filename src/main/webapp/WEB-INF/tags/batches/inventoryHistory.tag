<%-- 
    Document   : inventoryHistory
    Created on : Jul 14, 2015, 2:49:01 PM
    Author     : focke
--%>

<%@tag description="Show the history of a Hardware batch" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>

<%@attribute name="hardwareId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="total" scope="AT_BEGIN"%>

<h2>Inventory History</h2>

    <sql:query var="historyQ">
select BIH.*, P.name as processName
from BatchedInventoryHistory BIH
left join (Activity A inner join Process P on P.id=A.processId) on A.id=BIH.activityId
where BIH.hardwareId=?<sql:param value="${hardwareId}"/> 
order by id desc;
    </sql:query>

<display:table name="${historyQ.rows}" id="row" varTotals="totals"
               class="datatable" sort="list"
               pagesize="${fn:length(historyQ.rows) > preferences.pageLength ? preferences.pageLength : 0}">
    <display:column property="reason" sortable="true" headerClass="sortable"/>
    <display:column property="adjustment" sortable="true" headerClass="sortable" total="true"/>
    <display:column property="processName" title="Step" sortable="true" headerClass="sortable"
                      href="displayActivity.jsp" paramId="activityId" paramProperty="activityId"/>
    <display:column property="createdBy" title="Who" sortable="true" headerClass="sortable"/>
    <display:column property="creationTS" title="When" sortable="true" headerClass="sortable"/>
    <display:footer>
        <tr><td>Total</td><td><c:out value="${totals.column2}"/></td></tr>
    </display:footer>
</display:table>

<c:set var="total" value="${totals.column2}"/>
