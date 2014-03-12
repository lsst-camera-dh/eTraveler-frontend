<%-- 
    Document   : activityWidget
    Created on : May 17, 2013, 1:16:30 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId"%>

<sql:query var="activityQ" >
    select A.*, AFS.name as statusName,
    P.travelerActionMask&(select maskBit from InternalAction where name='harnessedJob') as isHarnessed,
    P.substeps
    from Activity A
    inner join Process P on P.id=A.processId
    left join ActivityFinalStatus AFS on AFS.id=A.activityFinalStatusId
    where A.id=?<sql:param value="${activityId}"/>;
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<traveler:activityPrereqWidget activityId="${activityId}"/>
<c:if test="${activityQ.rows[0].substeps == 'SELECTION'}"><traveler:selectionWidget activityId="${activityId}"/></c:if>
<c:set var="resultsFiled" value="true" scope="request"/> <%-- activityInputWidget will set this to "false" if that's the case --%>
<traveler:activityInputWidget activityId="${activityId}"/>
<table>
    <tr>
        <td>Started:</td>
        <td>
            <c:choose>
                <c:when test="${empty activity.begin}">
                    In Prep
                </c:when>
                <c:otherwise>
                    <c:out value="${activity.begin}"/> by <c:out value="${activity.createdBy}"/>
                </c:otherwise>
            </c:choose>
        </td>
    </tr>
    <tr><td>End:</td>
        <td>
            <c:if test="${resultsFiled}">
                <traveler:closeoutButton activityId="${activityId}"/>
            </c:if>
            <%--<c:if test="${! empty activity.end}">
                Ended at <c:out value="${activity.end}"/> by <c:out value="${activity.closedBy}"/>
            </c:if>--%>
        </td></tr>
        <c:if test="${! empty activity.statusName}">
        <tr><td>Status:</td><td>${activity.statusName}</td></tr>
        </c:if>
</table>

<c:if test="${activity.isHarnessed != 0}">
    <h3>Job Harness History</h3>
    <sql:query var="historyQ" >
        select JSH.*, JHS.name
        from JobStepHistory JSH
        inner join JobHarnessStep JHS on JHS.id=JSH.jobHarnessStepId
        where JSH.activityId=?<sql:param value="${activityId}"/>
        order by JSH.id desc
    </sql:query>
    <display:table name="${historyQ.rows}" class="datatable">
        <display:column property="name" sortable="true" headerClass="sortable"/>
        <display:column property="errorString" sortable="true" headerClass="sortable"/>
        <display:column property="createdBy" sortable="true" headerClass="sortable"/>
        <display:column property="creationTS" sortable="true" headerClass="sortable"/>
    </display:table>
</c:if>