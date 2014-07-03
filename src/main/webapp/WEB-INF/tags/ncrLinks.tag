<%-- 
    Document   : ncrLinks
    Created on : Jul 3, 2014, 11:53:12 AM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>
<%@attribute name="mode" required="true"%>

<c:set var="description" value="${mode}ing"/>

<sql:query var="exceptionQ">
    select EI.NCRActivityId, ET.conditionString, A.begin, A.end
    from Exception EI
    inner join ExceptionType ET on ET.id=EI.exceptionTypeId
    inner join Activity A on A.id=EI.NCRActivityId
    where EI.${mode}ActivityId=?<sql:param value="${activityId}"/>;
</sql:query>

<c:choose>
    <c:when test="${! empty exceptionQ.rows}">
        <h3>${description} NCRs</h3>
        <display:table name="${exceptionQ.rows}" id="row" class="datatable">
            <display:column title="Exception" sortable="true" headerClass="sortable">
                <c:url var="ncrLink" value="displayActivity.jsp">
                    <c:param name="activityId" value="${row.NCRActivityId}"/>
                </c:url>
                <a href="${ncrLink}" target="_top">${row.conditionString}</a>
            </display:column>
            <display:column property="begin" sortable="true" headerClass="sortable"/>
            <display:column property="end" sortable="true" headerClass="sortable"/>
        </display:table>    
    </c:when>
    <c:otherwise>
        <h3>No ${description} NCRs for this activity.</h3>
    </c:otherwise>
</c:choose>