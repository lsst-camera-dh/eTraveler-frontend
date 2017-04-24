<%-- 
    Document   : createTraveler
    Created on : Jul 2, 2014, 11:24:10 AM
    Author     : focke
--%>

<%@tag description="Start a process traveler" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="hardwareId" required="true"%>
<%@attribute name="processId" required="true"%>
<%@attribute name="jobHarnessId"%>
<%@attribute name="exceptionTypeId"%>
<%@attribute name="exitActivityId"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="activityId" scope="AT_BEGIN"%>

<c:set var="inNCR" value="${! empty exceptionTypeId}"/>

<%-- check if there are any harnessed steps in traveler --%>
<traveler:hasHarnessedSteps var="hasHarnessed" processId="${processId}"/>

<c:choose>
    <c:when test="${hasHarnessed}">
        <ta:createActivity var="activityId"
            hardwareId="${hardwareId}" processId="${processId}" inNCR="${inNCR}" jobHarnessId="${jobHarnessId}"/>
    </c:when>
    <c:otherwise>
        <ta:createActivity var="activityId"
            hardwareId="${hardwareId}" processId="${processId}" inNCR="${inNCR}"/>
    </c:otherwise>
</c:choose>

<c:if test="${inNCR}">
    <c:if test="${empty exitActivityId}">
        <c:set var="isNcrTraveler" value="true"/>
        <c:set var="exitActivityId" value="${activityId}"/>
    </c:if>
    <sql:update>
insert into Exception set
exceptionTypeId=?<sql:param value="${exceptionTypeId}"/>,
exitActivityId=?<sql:param value="${exitActivityId}"/>,
NCRActivityId=?<sql:param value="${activityId}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=UTC_TIMESTAMP();
    </sql:update>
</c:if>

<ta:createRun activityId="${activityId}"/>

<sql:query var="hardwareQ">
    select H.*, HS.name
    from Hardware H
    inner join HardwareStatusHistory HSH on HSH.hardwareId=H.id and HSH.id=(select max(HSH2.id) from HardwareStatusHistory HSH2 inner join HardwareStatus HS on HS.id=HSH2.hardwareStatusId where HSH2.hardwareId=H.id and HS.isStatusValue=1)
    inner join HardwareStatus HS on HS.id=HSH.hardwareStatusId
    where H.id=?<sql:param value="${hardwareId}"/>;
</sql:query>
<c:if test="${hardwareQ.rows[0].name == 'NEW'}">
    <ta:setHardwareStatus hardwareId="${hardwareId}" hardwareStatusName="IN_PROGRESS" reason="First Process Traveler" activityId="${activityId}"/>
</c:if>
