<%-- 
    Document   : childBatches
    Created on : Jun 17, 2016, 4:23:06 PM
    Author     : focke
--%>

<%@tag description="display info about child batches" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>

<%@attribute name="hardwareId" required="true"%>

info about child batches for batch ${hardwareId}

    <sql:query var="childrenQ">
select BIH.*, H.id as hardwareId, H.lsstId
from BatchedInventoryHistory BIH
inner join Hardware H on H.id = BIH.hardwareId
where BIH.sourceBatchId = ?<sql:param value="${hardwareId}"/>
and BIH.id = (select min(id) from BatchedInventoryHistory where hardwareId = BIH.hardwareId and sourceBatchId = BIH.sourceBatchId);
    </sql:query>

<c:if test="${! empty childrenQ.rows}">
    <h2>Child Batches</h2>
    <display:table name="${childrenQ.rows}" id="row" varTotals="totals"
                   class="datatable" sort="list"
                   pagesize="${fn:length(childrenQ.rows) > preferences.pageLength ? preferences.pageLength : 0}">
        <display:column property="lsstId" title="Serial" sortable="true" headerClass="sortable"
                        href="displayHardware.jsp" paramId="hardwareId" paramProperty="hardwareId"/>
        <display:column property="reason" sortable="true" headerClass="sortable"/>
        <display:column property="createdBy" title="Who" sortable="true" headerClass="sortable"/>
        <display:column property="creationTS" title="When" sortable="true" headerClass="sortable"/>
    </display:table>
</c:if>
