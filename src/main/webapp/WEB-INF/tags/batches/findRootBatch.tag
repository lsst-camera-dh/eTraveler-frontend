<%-- 
    Document   : findRootBatch
    Created on : Jul 13, 2016, 3:06:03 PM
    Author     : focke
--%>

<%@tag description="find the original batch that a subbatch is descended from" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="batch" tagdir="/WEB-INF/tags/batches"%>

<%@attribute name="hardwareId" required="true"%>
<%@attribute name="recurse"%>

    <sql:query var="parentQ">
select BIH.sourceBatchId, Hc.lsstId as childLsstId, Hp.lsstId as parentLsstId
from BatchedInventoryHistory BIH
inner join Hardware Hc on Hc.id = BIH.hardwareId
left join Hardware Hp on Hp.id = BIH.sourceBatchId
where BIH.hardwareId = ?<sql:param value="${hardwareId}"/>
order by BIH.id limit 1;
    </sql:query>
<c:set var="parent" value="${parentQ.rows[0]}"/>

<c:if test="${empty recurse && ! empty parent.sourceBatchId}">
    <c:url var="parentUrl" value="displayHardware.jsp">
        <c:param name="hardwareId" value="${parent.sourceBatchId}"/>
    </c:url>
Parent Batch: <a href="${parentUrl}">${parent.parentLsstId}</a>
</c:if>

<c:choose>
    <c:when test="${empty parent.sourceBatchId}">
        <c:url var="rootUrl" value="displayHardware.jsp">
            <c:param name="hardwareId" value="${hardwareId}"/>
        </c:url>
Root Batch: <a href="${rootUrl}">${parent.childLsstId}</a>
    </c:when>
    <c:otherwise>
        <batch:findRootBatch hardwareId="${parentQ.rows[0].sourceBatchId}" recurse="true"/>
    </c:otherwise>
</c:choose>
