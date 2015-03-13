<%-- 
    Document   : jhWidget
    Created on : Mar 17, 2014, 12:03:23 PM
    Author     : focke
--%>

<%@tag description="Display job harness-related stuff for an Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>

<sql:query var="historyQ" >
    select JSH.*, JHS.name
    from JobStepHistory JSH
    inner join JobHarnessStep JHS on JHS.id=JSH.jobHarnessStepId
    where JSH.activityId=?<sql:param value="${activityId}"/>
    order by JSH.id desc
</sql:query>
    
<c:choose>
    <c:when test="${! empty historyQ.rows}">
        <%-- display the history --%>
        <h3>Job Harness History</h3>
        <display:table name="${historyQ.rows}" class="datatable">
            <display:column property="name" sortable="true" headerClass="sortable"/>
            <display:column property="errorString" sortable="true" headerClass="sortable"/>
            <display:column property="createdBy" sortable="true" headerClass="sortable"/>
            <display:column property="creationTS" sortable="true" headerClass="sortable"/>
        </display:table>
    </c:when>
    <c:otherwise>
        <%-- Try to show the jh command --%>
        <c:if test="${empty activity.end}">
            <traveler:jhCommand var="command" varError="allOk" activityId="${activityId}"/>
Now enter the following command:<br>
<c:out value="${command}"/><br>
        </c:if>
    </c:otherwise>
</c:choose>
