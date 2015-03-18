<%-- 
    Document   : activityInputWidget
    Created on : Dec 12, 2013, 10:53:20 AM
    Author     : focke
--%>

<%@tag description="Handle manual inputs for an Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%@attribute name="activityId" required="true"%>

<sql:query var="inputQ" >
    select A.begin, A.end, IP.*, RM.value, ISm.name as ISName
    from Activity A
    inner join InputPattern IP on IP.processId=A.processId
    inner join InputSemantics ISm on ISm.id=IP.inputSemanticsId
    left join FloatResultManual RM on RM.activityId=A.id and RM.inputPatternId=IP.id
    where A.id=?<sql:param value="${activityId}"/>
    and ISm.name='float'
    union
    select A.begin, A.end, IP.*, RM.value, ISm.name as ISName
    from Activity A
    inner join InputPattern IP on IP.processId=A.processId
    inner join InputSemantics ISm on ISm.id=IP.inputSemanticsId
    left join IntResultManual RM on RM.activityId=A.id and RM.inputPatternId=IP.id
    where A.id=?<sql:param value="${activityId}"/>
    and ISm.name='int'
    union
    select A.begin, A.end, IP.*, RM.value, ISm.name as ISName
    from Activity A
    inner join InputPattern IP on IP.processId=A.processId
    inner join InputSemantics ISm on ISm.id=IP.inputSemanticsId
    left join StringResultManual RM on RM.activityId=A.id and RM.inputPatternId=IP.id
    where A.id=?<sql:param value="${activityId}"/>
    and ISm.name='string'
    union
    select A.begin, A.end, IP.*, RM.value, ISm.name as ISName
    from Activity A
    inner join InputPattern IP on IP.processId=A.processId
    inner join InputSemantics ISm on ISm.id=IP.inputSemanticsId
    left join FilepathResultManual RM on RM.activityId=A.id and RM.inputPatternId=IP.id
    where A.id=?<sql:param value="${activityId}"/>
    and ISm.name='filepath'
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
                <c:when test="${empty row.begin}">
                    Not yet
                </c:when>
                <c:when test="${! empty row.end}">
                    ERROR: no value found
                </c:when>
                <c:otherwise>
                    <c:set var="resultsFiled" value="false" scope="request"/>
                    <c:choose>
                        <c:when test="${row.ISName == 'string'}">
                            <c:set var="inputType" value="text"/>
                        </c:when>
                        <c:when test="${row.ISName == 'filepath'}">
                            <c:set var="inputType" value="file"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="inputType" value="number"/>
                        </c:otherwise>
                    </c:choose>
                    <form method="get" action="fh/inputResult.jsp">
                        <input type="hidden" name="activityId" value="${activityId}">
                        <input type="hidden" name="inputPatternId" value="${row.id}">
                        <input type="hidden" name="ISName" value="${row.ISName}">
                        *<input type="${inputType}" name="value" required
                                <c:if test="${row.ISName=='float'}">step="any"</c:if>
                                <c:if test="${!empty row.minV}">min="<c:out value="${row.minV}"/>"</c:if>
                                <c:if test="${!empty row.maxV}">max="<c:out value="${row.maxV}"/>"</c:if>
                                >
                        <input type="submit" value="Record Result">
                    </form>
                </c:otherwise>
            </c:choose>
        </display:column>
        <display:column property="description"/>
    </display:table>
</c:if>