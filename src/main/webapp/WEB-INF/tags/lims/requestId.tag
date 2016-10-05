<%-- 
    Document   : limsRequestId
    Created on : Nov 1, 2013, 4:36:11 PM
    Author     : focke
--%>

<%@tag description="Give the job harness an Id for the job" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<sql:query var="activityQ" >
    select A.id
    from 
    Activity A
    inner join Hardware H on A.hardwareId=H.id
    inner join Process P on A.processId=P.id
    inner join HardwareType HT on HT.id=H.hardwareTypeId
    inner join ActivityStatusHistory ASH on ASH.activityId=A.id and ASH.id=(select max(id) from ActivityStatusHistory where activityId=A.id)
    inner join ActivityFinalStatus AFS on AFS.id=ASH.activityStatusId
    where
    H.lsstId=?<sql:param value="${inputs.unit_id}"/>
    and P.name=?<sql:param value="${inputs.job}"/>
    and P.userVersionString=?<sql:param value="${inputs.version}"/>
    and P.travelerActionMask&(select maskBit from InternalAction where name='harnessedJob')!=0
    and HT.name=?<sql:param value="${inputs.unit_type}"/>
    and A.begin is not null
    and A.end is null
    and AFS.name='inProgress'
    order by A.id desc limit 1;
</sql:query>
<c:if test="${empty activityQ.rows}">
    <traveler:error message="No record found."/>
</c:if>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<traveler:findRun varRun="runNumber" varTraveler="rootActivityId" activityId="${activity.id}"/>

<sql:query var="prereqQ" >
    select A.id as activityId, A.hardwareId, A.createdBy,
    H.lsstId,
    HT.name as hardwareTypeName, 
    P.name as processName, P.userVersionString
    from
    Prerequisite PI
    inner join Activity A on A.id=PI.prerequisiteActivityId
    inner join Process P on P.id=A.processId
    inner join Hardware H on H.id=A.hardwareId
    inner join HardwareType HT on HT.id=H.hardwareTypeId
    where
    PI.activityId=?<sql:param value="${activity.id}"/>
</sql:query>
<sql:update >
    insert into JobStepHistory set
    jobHarnessStepId=(select id from JobHarnessStep where name='registered'),
    activityId=?<sql:param value="${activity.id}"/>,
    createdBy=?<sql:param value="${inputs.operator}"/>,
    creationTS=UTC_TIMESTAMP();
</sql:update>

{
    "jobid": "${activity.id}",
    "runNumber": "${runNumber}",
    "rootActivityId": "${rootActivityId}",
    "prereq": [<c:forEach var="prereqRow" items="${prereqQ.rows}" varStatus="status">
               <traveler:findRun varRun="runNumber" varTraveler="rootActivityId" activityId="${prereqRow.activityId}"/>
        {
            "jobid": "${prereqRow.activityId}",
            "runNumber": "${runNumber}",
            "rootActivityId": "${rootActivityId}",
            "unit_type": "${prereqRow.hardwareTypeName}",
            "unit_id": "${prereqRow.lsstId}",
            "job": "${prereqRow.processName}",
            "version": "${prereqRow.userVersionString}",
            "operator": "${prereqRow.createdBy}"
        }<c:if test="${! status.last}">,</c:if>
    </c:forEach>]
}
