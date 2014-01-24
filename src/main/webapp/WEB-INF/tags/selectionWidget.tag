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
    Ap.hardwareId, Ap.inNCR,
    PE.child, PE.id as edgeId, PE.step,
    P.name,
    Ac.creationTS
    from Activity Ap
    inner join ProcessEdge PE on PE.parent=Ap.processId
    inner join Process P on P.id=PE.child
    left join Activity Ac on Ac.parentActivityId=Ap.id and Ac.processEdgeId=PE.id
    where Ap.id=?<sql:param value="${activityId}"/>
    order by abs(PE.step);
</sql:query>

<c:set var="numChosen" value="0"/>
<c:forEach items="${choicesQ.rows}" var="childRow">
    <c:if test="${! empty childRow.creationTS}">
        <c:set var="numChosen" value="${numChosen + 1}"/>
    </c:if>
</c:forEach>

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
