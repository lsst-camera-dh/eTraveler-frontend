<%-- 
    Document   : expandProcessRows
    Created on : Jul 24, 2014, 11:43:14 AM
    Author     : focke
--%>

<%@tag description="Add all rows but the first to the list created by expandProcess.tag" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="processId" required="true"%>
<%@attribute name="stepPrefix"%>
<%@attribute name="edgePrefix"%>
<%@attribute name="processPrefix" required="true"%>
<%@attribute name="stepList" required="true" type="java.util.List"%>

<traveler:dotOrNot var="myStepPrefix" prefix="${stepPrefix}"/>
<traveler:dotOrNot var="myEdgePrefix" prefix="${edgePrefix}"/>
<traveler:dotOrNot var="myProcessPrefix" prefix="${processPrefix}"/>

<sql:query var="childrenQ" >
    select 
    PE.id as processEdgeId, PE.child, PE.step, 
    P.name, P.id as processId, P.substeps,
    concat('${myStepPrefix}', abs(PE.step)) as stepPath,
    concat('${myEdgePrefix}', PE.id) as edgePath,
    concat('${myProcessPrefix}', P.id) as processPath
    from ProcessEdge PE
    inner join Process P on P.id=PE.child
    where PE.parent=?<sql:param value="${processId}"/>
    order by abs(PE.step);
</sql:query>

<c:forEach var="cRow" items="${childrenQ.rows}">
    <%
        ((java.util.List)jspContext.getAttribute("stepList")).add(jspContext.getAttribute("cRow"));
    %>
    <c:if test="${cRow.substeps != 'NONE'}">
        <traveler:expandProcessRows
            stepList="${stepList}"
            processId="${cRow.processId}" 
            stepPrefix="${cRow.stepPath}"
            edgePrefix="${cRow.edgePath}"
            processPrefix="${cRow.processPath}"/>
    </c:if>
</c:forEach>
