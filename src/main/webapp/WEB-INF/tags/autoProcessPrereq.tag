<%-- 
    Document   : autoProcessPrereq
    Created on : Aug 11, 2014, 2:14:26 PM
    Author     : focke
--%>

<%@tag description="Automatically fill process prereqs for scripted JH steps." pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="gotAll" scope="AT_BEGIN"%>

<sql:query var="unfilledPrereqsQ" >
    select A.hardwareId, A.rootActivityId, PP.id as ppid, PP.prereqProcessId, PI.id as piid
    from
    Activity A
    inner join PrerequisitePattern PP on PP.processId=A.processId
    left join Prerequisite PI on PI.prerequisitePatternId=PP.id and PI.activityId=A.id
    where
    A.id=?<sql:param value="${activityId}"/>
    and PP.prerequisiteTypeid=(select id from PrerequisiteType where name='PROCESS_STEP')
    and PI.id is null;
</sql:query>
<c:set var="gotAll" value="true"/>
<c:forEach var="prereq" items="${unfilledPrereqsQ.rows}">

    <sql:query var="activityQ" >
select A.id, A.rootActivityId
from Activity A
inner join ActivityStatusHistory ASH on ASH.activityId=A.id and ASH.id=(select max(id) from ActivityStatusHistory where activityId=A.id)
inner join ActivityFinalStatus AFS on AFS.id=ASH.activityStatusId
where
A.hardwareId=?<sql:param value="${prereq.hardwareId}"/>
and A.processId=?<sql:param value="${prereq.prereqProcessId}"/>
and A.rootActivityId=?<sql:param value="${prereq.rootActivityId}"/>
and ASH.activityStatusId=(select id from ActivityFinalStatus where name='success')
order by A.end desc limit 1;
    </sql:query>
    <c:choose>
        <c:when test="${! empty activityQ.rows}">
            <sql:update >
insert into Prerequisite set
prerequisitePatternId=?<sql:param value="${prereq.ppid}"/>,
activityId=?<sql:param value="${activityId}"/>,
prerequisiteActivityId=?<sql:param value="${activityQ.rows[0].id}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=UTC_TIMESTAMP();
            </sql:update>
        </c:when>
        <c:otherwise>
            <c:set var="gotall" value="false"/>
        </c:otherwise>
    </c:choose>
</c:forEach>
