<%-- 
    Document   : subBatchForm
    Created on : Jul 15, 2016, 4:25:57 PM
    Author     : focke
--%>

<%@tag description="form to make a child batch" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="hardwareId" required="true"%>

    <sql:query var="parentQ">
select ((select sum(adjustment) from BatchedInventoryHistory where hardwareId = ?<sql:param value="${hardwareId}"/>)
    - ifnull((select sum(adjustment) from BatchedInventoryHistory where sourceBatchId = ?<sql:param value="${hardwareId}"/>), 0)) as quantity;
    </sql:query>
    
<form action="batches/createSubBatch.jsp">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
    <input type="hidden" name="parentId" value="${hardwareId}">
    <input type="submit" value="Create Child Batch">
    How many?&nbsp;<input type="number" name="numItems" min="1" max="${parentQ.rows[0].quantity}" required>
    Why?&nbsp;<input type="text" name="reason">
</form>