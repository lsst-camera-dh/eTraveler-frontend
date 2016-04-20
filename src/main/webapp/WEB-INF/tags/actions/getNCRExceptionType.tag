<%-- 
    Document   : getNCRExceptionType
    Created on : Mar 4, 2016, 4:10:11 PM
    Author     : focke
--%>

<%@tag description="find or create an ExceptionType linking 
       the current generic NCR traveler to the current step" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="exceptionTypeId" scope="AT_BEGIN"%>

<sql:query var="activityQ">
select * from Activity where id=?<sql:param value="${activityId}"/>;
</sql:query>
<c:set var="processId" value="${activityQ.rows[0].processId}"/>
p:${processId}<br>

<traveler:findTraveler var="travelerId" activityId="${activityId}"/>
<sql:query var="travelerQ">
select * from Activity where id=?<sql:param value="${travelerId}"/>;
</sql:query>
<c:set var="rootProcessId" value="${travelerQ.rows[0].processId}"/>
t:${travelerId} rp:${rootProcessId}<br>

<traveler:findPath var="edgePath" activityId="${activityId}"/>
path:${edgePath}<br>

<sql:query var="ncrQ">
select P.id
from Process P
inner join TravelerType TT on TT.rootProcessId=P.id
inner join TravelerTypeStateHistory TTSH on TTSH.travelerTypeId=TT.id 
    and TTSH.id=(select max(id) from TravelerTypeStateHistory where travelerTypeId=TT.id)
inner join TravelerTypeState TTS on TTS.id=TTSH.travelerTypeStateId
inner join HardwareGroup HG on HG.id=P.hardwareGroupId
where P.name='NCR' 
and HG.name='Anything'
and TTS.name='active'
order by P.id desc
limit 1
;
</sql:query>
<c:set var="ncrProcessId" value="${ncrQ.rows[0].id}"/>
n:${ncrProcessId}<br>

<sql:query var="etQ">
select id from ExceptionType
where exitProcessPath=?<sql:param value="${edgePath}"/>
and returnProcessPath=?<sql:param value="${edgePath}"/>
and exitProcessId=?<sql:param value="${processId}"/>
and rootProcessId=?<sql:param value="${rootProcessId}"/>
and NCRProcessId=?<sql:param value="${ncrProcessId}"/>
and returnProcessId=?<sql:param value="${processId}"/>
and status='ENABLED'
;
</sql:query>
<c:if test="${empty etQ.rows}">
    <sql:update>
insert into ExceptionType set
conditionString="NCR",
exitProcessPath=?<sql:param value="${edgePath}"/>,
returnProcessPath=?<sql:param value="${edgePath}"/>,
exitProcessId=?<sql:param value="${processId}"/>,
rootProcessId=?<sql:param value="${rootProcessId}"/>,
NCRProcessId=?<sql:param value="${ncrProcessId}"/>,
returnProcessId=?<sql:param value="${processId}"/>,
status='ENABLED',
createdBy=?<sql:param value="${userName}"/>,
creationTS=utc_timestamp()
;
    </sql:update>
    <sql:query var="etQ">
select last_insert_id() as id;
    </sql:query>
</c:if>
<c:set var="exceptionTypeId" value="${etQ.rows[0].id}"/>
e:${exceptionTypeId}<br>
