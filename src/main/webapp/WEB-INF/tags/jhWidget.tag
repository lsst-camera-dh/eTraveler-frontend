<%-- 
    Document   : jhWidget
    Created on : Mar 17, 2014, 12:03:23 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
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
        <sql:query var="activityQ">
            select
            P.name as processName, P.userVersionString,
            H.lsstId,
            HT.name as hardwareTypeName
            from Activity A
            inner join Process P on P.id=A.processId
            inner join Hardware H on H.id=A.hardwareId
            inner join HardwareType HT on HT.id=H.hardwareTypeId
            where A.id=?<sql:param value="${activityId}"/>
        </sql:query>
        <c:set var="activity" value="${activityQ.rows[0]}"/>
        
        <c:set var="command">lcatr-harness --unit-type ${activity.hardwareTypeName} --unit-id ${activity.lsstId} --job ${activity.processName} --version ${activity.userVersionString}</c:set>
Now enter the following command:<br>
<c:out value="${command}"/>
    </c:otherwise>
</c:choose>
