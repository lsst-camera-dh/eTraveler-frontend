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
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="rootId" scope="AT_BEGIN"%>

<sql:query var="parentQ">
    select field from table where condition;
</sql:query>

<c:choose>
    <c:when test="${empty parentQ.rows[0].sourceBatchId}">
        <c:set var="rootId" value="${hardwareId}"/>
    </c:when>
    <c:otherwise>
        <batch:findRootBatch var="rootId" hardwareId="${parentQ.rows[0].sourceBatchId}"/>
    </c:otherwise>
</c:choose>
