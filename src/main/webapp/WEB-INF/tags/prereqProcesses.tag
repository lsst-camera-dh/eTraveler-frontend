<%-- 
    Document   : prereqProcesses
    Created on : Nov 6, 2013, 4:20:34 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>

<%@attribute name="activityId" required="true"%>

<sql:query var="unfilledPrereqsQ" dataSource="jdbc/rd-lsst-cam">
    select A.hardwareId, PP.id as ppid, PP.prereqProcessId, PI.id as piid
    from
    Activity A
    inner join PrerequisitePattern PP on PP.processId=A.processId
    left join Prerequisite PI on PI.prerequisitePatternId=PP.id and PI.activityId=A.id
    where 
    A.id=?<sql:param value="${activityId}"/>
    and PP.prerequisiteTypeid=(select id from PrerequisiteType where name='PROCESS_STEP')
    and PI.id is null;
</sql:query>
<c:forEach var="prereq" items="${unfilledPrereqsQ.rows}">
    <c:out value="${prereq.prereqProcessId}"/>
    <sql:query var="activityQ" dataSource="jdbc/rd-lsst-cam">
        select id from Activity where
        hardwareId=?<sql:param value="${prereq.hardwareId}"/>
        and processId=?<sql:param value="${prereq.prereqProcessId}"/>
        and activityFinalStatusId=(select id from ActivityFinalStatus where name='success')
        order by end desc limit 1;
    </sql:query>
    <c:if test="${! empty activityQ.rows}">
        <sql:update dataSource="jdbc/rd-lsst-cam">
            insert into Prerequisite set
            prerequisitePatternId=?<sql:param value="${prereq.ppid}"/>,
            activityId=?<sql:param value="${activityId}"/>,
            prerequisiteActivityId=?<sql:param value="${activityQ.rows[0].id}"/>,
            createdBy=?<sql:param value="${userName}"/>,
            creationTS=now();
        </sql:update>
    </c:if>
</c:forEach>
        
<sql:query var="filledPrereqsQ" dataSource="jdbc/rd-lsst-cam">
    select PP.name as patternName, P.id as processId, P.name as processName, P.userVersionString, Ac.id as activityId, Ac.end
    from
    Activity Ap
    inner join PrerequisitePattern PP on PP.processId=Ap.processId
    left join (Prerequisite PI
    inner join Activity Ac on Ac.id=PI.prerequisiteActivityId
    inner join Process P on P.id=Ac.processId) on PI.prerequisitePatternId=PP.id and PI.activityId=Ap.id
    where Ap.id=?<sql:param value="${activityId}"/>
    and PP.prerequisiteTypeid=(select id from PrerequisiteType where name='PROCESS_STEP');
</sql:query>
<c:if test="${! empty filledPrereqsQ.rows}">
    <h2>Required Steps</h2>
    <display:table name="${filledPrereqsQ.rows}" id="row" class="datatable">
        <display:column property="patternName" title="Pattern"/>
        <display:column property="processName" title="Job"/>
        <display:column property="userVersionString" title="Version"/>
        <display:column property="end" title="Completion"/>
    </display:table>
</c:if>