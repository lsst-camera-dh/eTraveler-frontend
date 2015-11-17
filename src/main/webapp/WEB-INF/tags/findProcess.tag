<%-- 
    Document   : findProcess
    Created on : Nov 13, 2015, 3:58:56 PM
    Author     : focke
--%>

<%@tag description="find a process" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="name" required="true"%>
<%@attribute name="version"%>
<%@attribute name="hardwareGroup" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="processId" scope="AT_BEGIN"%>

    <sql:query var="processQ">
select P.id 
from Process P
inner join HardwareGroup HG on HG.id=P.hardwareGroupId
inner join TravelerType TT on TT.rootProcessId=P.id
<c:choose>
    <c:when test="${empty version}">
inner join TravelerTypeStateHistory TTSH on TTSH.travelerTypeId=TT.id
    and TTSH.id=(select max(id) from TravelerTypeStateHistory where travelerTypeId=TT.id)
inner join TravelerTypeState TTS on TTS.id=TTSH.travelerTypeStateId
where TTS.name='active'
    </c:when>
    <c:otherwise>
where P.version=?<sql:param value="${version}"/>
    </c:otherwise>
</c:choose>
and P.name=?<sql:param value="${name}"/>
and HG.name=?<sql:param value="${hardwareGroup}"/>
order by P.id desc limit 1
;
    </sql:query>

<c:if test="${empty processQ.rows}">
    <traveler:error message="No Process with name=${name} version=${version} hardwareGroup=${hardwareGroup} found."/>
</c:if>

<c:set var="processId" value="${processQ.rows[0].id}"/>
