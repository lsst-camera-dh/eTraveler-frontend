<%-- 
    Document   : getSsName
    Created on : May 5, 2016, 3:50:27 PM
    Author     : focke
--%>

<%@tag description="find the name of a subsystem" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="subsystemId"%>
<%@attribute name="activityId"%>
<%@attribute name="travelerTypeId"%>
<%@attribute name="processId"%>
<%@attribute name="hardwareId"%>
<%@attribute name="hardwareTypeId"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="subsystemName" scope="AT_BEGIN"%>

<c:choose>
    <c:when test="${! empty subsystemId}">
        <sql:query var="subsysQ">
select SS.shortName
from Subsystem SS
where id=?<sql:param value="${subsystemId}"/>
;
        </sql:query>
    </c:when>
    <c:when test="${! empty activityId}">
        <traveler:findTraveler var="travelerId" activityId="${activityId}"/>
        <sql:query var="subsysQ">
select SS.shortName
from Activity A
inner join TravelerType TT on TT.rootProcessId=A.processId
inner join Subsystem SS on SS.id=TT.subsystemId
where A.id=?<sql:param value="${travelerId}"/>
;
        </sql:query>
    </c:when>
    <c:when test="${! empty travelerTypeId}">
        <sql:query var="subsysQ">
select SS.shortName
from TravelerType TT
inner join Subsystem SS on SS.id=TT.subsystemId
where TT.id=?<sql:param value="${travelerTypeId}"/>
;
        </sql:query>
    </c:when>
    <c:when test="${! empty processId}">
        <sql:query var="subsysQ">
select SS.shortName
from TravelerType TT
inner join Subsystem SS on SS.id=TT.subsystemId
where TT.rootProcessId=?<sql:param value="${processId}"/>
;
        </sql:query>
        <c:if test="${empty subsysQ.rows}">
            <traveler:error message="checkSsPerm called with non-root process ${processId}" bug="true"/>
        </c:if>
    </c:when>
    <c:when test="${! empty hardwareId}">
        <sql:query var="subsysQ">
select SS.shortName 
from Hardware H
inner join HardwareType HT on HT.id=H.hardwareTypeId
inner join Subsystem SS on SS.id=HT.subsystemId
where H.id=?<sql:param value="${hardwareId}"/>
;
        </sql:query>
    </c:when>
    <c:when test="${! empty hardwareTypeId}">
        <sql:query var="subsysQ">
select SS.shortName 
from HardwareType HT
inner join Subsystem SS on SS.id=HT.subsystemId
where HT.id=?<sql:param value="${hardwareTypeId}"/>
;
        </sql:query>
    </c:when>
    <c:otherwise>
        <traveler:error message="Insufficient arguments to checkSsPerm" bug="true"/>
    </c:otherwise>
</c:choose>
<c:set var="subsystemName" value="${subsysQ.rows[0].shortName}"/>
