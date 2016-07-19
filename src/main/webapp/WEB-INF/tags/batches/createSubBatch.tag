<%-- 
    Document   : createSubBatch
    Created on : Jun 8, 2016, 12:29:22 PM
    Author     : focke
--%>

<%@tag description="make a subbatch of an existing batch" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="batch" tagdir="/WEB-INF/tags/batches"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="parentId" required="true"%>
<%@attribute name="numItems" required="true"%>
<%@attribute name="activityId"%>
<%@attribute name="reason"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="childId" scope="AT_BEGIN"%>

    <sql:query var="parentQ">
select H.*, HLH.locationId, 
HT.name, HT.isBatched, 
((select sum(adjustment) from BatchedInventoryHistory where hardwareId = H.id)
        - ifnull((select sum(adjustment) from BatchedInventoryHistory where sourceBatchId = H.id), 0)) as count
from Hardware H
inner join HardwareType HT on HT.id = H.hardwareTypeId
left join HardwareLocationHistory HLH on HLH.hardwareId = H.id
where H.id = ?<sql:param value="${parentId}"/>
order by HLH.id desc limit 1
;
    </sql:query>
<c:if test="${empty parentQ.rows}">
    <traveler:error message="No parent batch ${parentId}!"/>
</c:if>
<c:set var="parent" value="${parentQ.rows[0]}"/>

<c:if test="${parent.isBatched == 0}">
    <traveler:error message="Parent ${parentId} is not a batched type"/>
</c:if>

<c:if test="${parent.count < numItems}">
    <traveler:error message="Not enough items in parent batch ${parentId} (${parent.count} < ${numItems})"/>
</c:if>

<ta:createHardware var="childId"
                   hardwareTypeId="${parent.hardwareTypeId}"
                   subBatch="true"
                   quantity="${numItems}"
                   manufacturer="${parent.manufacturer}"
                   manufacturerId="${parent.manufacturerId}"
                   model="${parent.model}"
                   manufactureDateStr="${parent.manufactureDate}"
                   locationId="${parent.locationId}"/>

<c:if test="${empty reason}">
    <c:set var="reason" value="Moved to child batch ${childId}"/>
</c:if>

<batch:adjustInventory hardwareId="${childId}"
                       sourceBatchId="${parentId}"
                       adjustment="${numItems}"
                       reason="${reason}"
                       activityId="${activityId}"/>
