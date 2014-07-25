<%-- 
    Document   : processStepListRows
    Created on : Jul 24, 2014, 11:43:14 AM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="processId" required="true"%>
<%@attribute name="stepPrefix"%>
<%@attribute name="edgePrefix"%>
<%@attribute name="processPrefix"%>

<traveler:dotOrNot var="myStepPrefix" prefix="${stepPrefix}"/>
<traveler:dotOrNot var="myEdgePrefix" prefix="${edgePrefix}"/>
<traveler:dotOrNot var="myProcessPrefix" prefix="${processPrefix}"/>

<sql:query var="childrenQ" >
    select 
    PE.child, PE.step, P.name, P.id as processId, P.substeps,
    concat('${myStepPrefix}', PE.step) as stepPath,
    concat('${myEdgePrefix}', PE.id) as edgePath,
    concat('${myProcessPrefix}', P.id) as processPath
    from ProcessEdge PE
    inner join Process P on P.id=PE.child
    where PE.parent=?<sql:param value="${processId}"/>
    order by abs(PE.step);
</sql:query>

<c:forEach var="cRow" items="${childrenQ.rows}">
    <c:set var="cRowJsp" value="${cRow}" scope="request"/>
    <%
        ((java.util.List)request.getAttribute("stepList")).add(request.getAttribute("cRowJsp"));
    %>
    <traveler:processStepListRows processId="${cRow.child}" 
                                  stepPrefix="${cRow.stepPath}"
                                  edgePrefix="${cRow.edgePath}"
                                  processPrefix="${cRow.processPath}"/>
</c:forEach>