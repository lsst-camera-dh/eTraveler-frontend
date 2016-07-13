<%-- 
    Document   : batchWidget
    Created on : Jun 17, 2016, 4:12:59 PM
    Author     : focke
--%>

<%@tag description="display stuff for batches" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="batch" tagdir="/WEB-INF/tags/batches"%>

<%@attribute name="hardwareId" required="true"%>
<%@attribute name="varTotal" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="varTotal" alias="total" scope="AT_BEGIN"%>

    <sql:query var="rootQ">
select id, lsstId from Hardware where id = rootBatchId(?<sql:param value="${hardwareId}"/>);
    </sql:query>
<c:set var="rootBatch" value="${rootQ.rows[0]}"/>
<c:url var="rootUrl" value="displayHardware.jsp">
    <c:param name="hardwareId" value="${rootBatch.id}"/>
</c:url>
Root Batch: <a href="${rootUrl}">${rootBatch.lsstId}</a>

<batch:inventoryHistory var="total" hardwareId="${hardwareId}"/>
<%--
<batch:inventoryForm hardwareId="${hardwareId}" quantity="${total}"/>
<batch:descent hardwareId="${hardwareId}"/>
--%>
