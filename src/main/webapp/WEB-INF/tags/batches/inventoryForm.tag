<%-- 
    Document   : inventoryForm
    Created on : Jun 17, 2016, 4:15:35 PM
    Author     : focke
--%>

<%@tag description="show forms to add or remove items from a batch" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="hardwareId" required="true"%>
<%@attribute name="quantity"%>

<traveler:fullRequestString var="thisPage"/>

<c:if test="${empty quantity}">
    <sql:query var="sourceQ">
((select sum(adjustment) from BatchedInventoryHistory where hardwareId = H.id)
        - ifnull((select sum(adjustment) from BatchedInventoryHistory where sourceBatchId = H.id), 0)) as quantity
    </sql:query>
    <c:set var="quantity" value="${sourceQ.rows[0].quantity}"/>
</c:if>

    <sql:query var="parentQ">
select BIH.sourceBatchId, Hc.lsstId as childLsstId, Hp.lsstId as parentLsstId
from BatchedInventoryHistory BIH
inner join Hardware Hc on Hc.id = BIH.hardwareId
left join Hardware Hp on Hp.id = BIH.sourceBatchId
where BIH.hardwareId = ?<sql:param value="${hardwareId}"/>
order by BIH.id limit 1;
    </sql:query>
<c:set var="parent" value="${parentQ.rows[0]}"/>

<c:if test="${! empty parent.sourceBatchId}">
    <form action="batches/adjustInventory.jsp">
        <input type="hidden" name="freshnessToken" value="${freshnessToken}">
        <input type="hidden" name="referringPage" value="${thisPage}">
        <input type="hidden" name="hardwareId" value="${parent.sourceBatchId}">
        <input type="hidden" name="sourceBatchId" value="${hardwareId}">
        <input type="submit" value="Transfer to Parent">
        How many?&nbsp;<input type="number" name="adjustment" min="1" max="${quantity}" required>
        Why?&nbsp;<input type="text" name="reason">
    </form>
</c:if>

    <sql:query var="childrenQ">
select H.id, H.lsstId
from BatchedInventoryHistory BIH
inner join Hardware H on H.id = BIH.hardwareId
where BIH.sourceBatchId = ?<sql:param value="${hardwareId}"/>
and BIH.id = (select min(id) from BatchedInventoryHistory where hardwareId = BIH.hardwareId and sourceBatchId = BIH.sourceBatchId);
    </sql:query>

<c:if test="${! empty childrenQ.rows}">
    <form action="batches/adjustInventory.jsp">
        <input type="hidden" name="freshnessToken" value="${freshnessToken}">
        <input type="hidden" name="referringPage" value="${thisPage}">
        <input type="hidden" name="sourceBatchId" value="${hardwareId}">
        <input type="submit" value="Transfer to Child">
        <select name="hardwareId" required>
            <option vale="" selected disabled>Select Child</option>
            <c:forEach var="child" items="${childrenQ.rows}">
                <option value="${child.id}">${child.lsstId}</option>
            </c:forEach>
        </select>
        How many?&nbsp;<input type="number" name="adjustment" min="1" max="${quantity}" required>
        Why?&nbsp;<input type="text" name="reason">
    </form>
</c:if>
