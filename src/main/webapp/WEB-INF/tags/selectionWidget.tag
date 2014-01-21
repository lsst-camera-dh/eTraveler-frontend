<%-- 
    Document   : selectionWidget
    Created on : Jan 15, 2014, 4:21:02 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>

<sql:query var="choicesQ">
    select 
    A.hardwareId, A.inNCR,
    PE.child, PE.id as edgeId,
    P.name
    from Activity A
    inner join ProcessEdge PE on PE.parent=A.processId
    inner join Process P on P.id=PE.child
    where A.id=?<sql:param value="${activityId}"/>
</sql:query>
    
<c:forEach items="${choicesQ.rows}" var="childRow">
    <form method="get" action="createActivity.jsp">
        <input type="hidden" name="parentActivityId" value="${activityId}">
        <input type="hidden" name="hardwareId" value="${choicesQ.rows[0].hardwareId}">
        <input type="hidden" name="inNCR" value="${choicesQ.rows[0].inNCR}">
        <input type="hidden" name="topActivityId" value="${param.topActivityId}">
        <input type="hidden" name="processId" value="${childRow.child}">
        <input type="hidden" name="processEdgeId" value="${childRow.edgeId}">
        <input type="submit" value="${childRow.name}">
    </form>
</c:forEach>
