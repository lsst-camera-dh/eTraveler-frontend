<%-- 
    Document   : inputWidget
    Created on : Dec 12, 2013, 10:53:20 AM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="processId" required="true"%>
<%@attribute name="activityId" required="true"%>

<sql:query var="inputQ" >
    select IP.*, RM.value, ISm.name as ISName
    from InputPattern IP
    inner join InputSemantics ISm on ISm.id=IP.inputSemanticsId
    left join FloatResultManual RM on RM.inputPatternId=IP.id
    where IP.processId=?<sql:param value="${processId}"/>
    and ISm.name='float'
    and (RM.activityId=?<sql:param value="${activityId}"/>
        or RM.activityId is null)
    union
    select IP.*, RM.value, ISm.name as ISName
    from InputPattern IP
    inner join InputSemantics ISm on ISm.id=IP.inputSemanticsId
    left join IntResultManual RM on RM.inputPatternId=IP.id
    where IP.processId=?<sql:param value="${processId}"/>
    and ISm.name='int'
    and (RM.activityId=?<sql:param value="${activityId}"/>
        or RM.activityId is null)
    union
    select IP.*, RM.value, ISm.name as ISName
    from InputPattern IP
    inner join InputSemantics ISm on ISm.id=IP.inputSemanticsId
    left join StringResultManual RM on RM.inputPatternId=IP.id
    where IP.processId=?<sql:param value="${processId}"/>
    and ISm.name='string'
    and (RM.activityId=?<sql:param value="${activityId}"/>
        or RM.activityId is null)
    union
    select IP.*, RM.value, ISm.name as ISName
    from InputPattern IP
    inner join InputSemantics ISm on ISm.id=IP.inputSemanticsId
    left join FilepathResultManual RM on RM.inputPatternId=IP.id
    where IP.processId=?<sql:param value="${processId}"/>
    and ISm.name='filepath'
    and (RM.activityId=?<sql:param value="${activityId}"/>
        or RM.activityId is null)
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
        <display:column title="Value">
            <c:choose>
                <c:when test="${! empty row.value}">
                    ${row.value}
                </c:when>
                <c:otherwise>
                    <form method="get" action="inputResult.jsp">
                        <input type="hidden" name="activityId" value="${activityId}">
                        <input type="hidden" name="inputPatternId" value="${row.id}">
                        <input type="hidden" name="ISName" value="${row.ISName}">
                        <input type="text" name="value">
                        <input type="submit" value="Submit!">
                    </form>
                </c:otherwise>
            </c:choose>
        </display:column>
        <display:column property="description"/>
    </display:table>
</c:if>