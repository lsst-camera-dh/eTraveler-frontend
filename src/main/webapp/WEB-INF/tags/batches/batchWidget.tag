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

<batch:inventoryHistory var="total" hardwareId="${hardwareId}"/>
<batch:findRootBatch hardwareId="${hardwareId}"/>
<batch:childBatches hardwareId="${hardwareId}"/>
<batch:subBatchForm hardwareId="${hardwareId}"/>
<%--
<batch:inventoryForm hardwareId="${hardwareId}" quantity="${total}"/>
<batch:descent hardwareId="${hardwareId}"/>
--%>
