<%-- 
    Document   : processInputWidget
    Created on : Dec 12, 2013, 10:53:20 AM
    Author     : focke
--%>

<%@tag description="Display InputPatterns for a Process" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>

<%@attribute name="processId" required="true"%>

<sql:query var="inputQ" >
    select IP.*, ISm.name as ISName
    from InputPattern IP
    inner join InputSemantics ISm on ISm.id=IP.inputSemanticsId
    where IP.processId=?<sql:param value="${processId}"/>
</sql:query>

<c:if test="${! empty inputQ.rows}">
    <h2>Results</h2>
    <display:table name="${inputQ.rows}" id="row" class="datatable">
        <display:column property="label" title="Name" sortable="true" headerClass="sortable"/>
        <display:column title="Type">
            <c:if test="${! empty row.minV or ! empty row.maxV}">${row.minV} - ${row.maxV}</c:if>
            <c:if test="${! empty row.units}">${row.units}</c:if>
            ${row.ISName}
        </display:column>
        <display:column property="description"/>
    </display:table>
</c:if>