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

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="hardwareId" required="true"%>
<%@attribute name="processId" required="true"%>
<%@attribute name="inNCR"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="activityId" scope="AT_BEGIN"%>

<c:if test="${empty inNCR}">
    <c:set var="inNCR" value="false"/>
</c:if>

<%-- TODO: check if there are any harnessed steps in traveler --%>
<traveler:hasHarnessedSteps var="hasHarnessed" processId="${processId}"/>
<c:if test="${hasHarnessed}">
    <sql:query var="jhQ">
select JH.id 
from JobHarness JH
inner join Site S on S.id=JH.siteId
where S.name=?<sql:param value="${preferences.siteName}"/>
and JH.name=?<sql:param value="${preferences.jhName}"/>
;
    </sql:query>
    <c:if test="${empty jhQ.rows}">
        <traveler:error message="Your Job Harness preference is ${preferences.jhName}, but there is no such install at site ${preferences.siteName}"/>
    </c:if>
</c:if>

<c:choose>
    <c:when test="${hasHarnessed}">
        <ta:createActivity var="activityId"
            hardwareId="${hardwareId}" processId="${processId}" inNCR="${inNCR}" jobHarnessId="${jhQ.rows[0].id}"/>
    </c:when>
    <c:otherwise>
        <ta:createActivity var="activityId"
            hardwareId="${hardwareId}" processId="${processId}" inNCR="${inNCR}"/>
    </c:otherwise>
</c:choose>

<sql:query var="hardwareQ">
    select H.*, HS.name
    from Hardware H
    inner join HardwareStatusHistory HSH on HSH.hardwareId=H.id and HSH.id=(select max(id) from HardwareStatusHistory where hardwareId=H.id)
    inner join HardwareStatus HS on HS.id=HSH.hardwareStatusId
    where H.id=?<sql:param value="${hardwareId}"/>;
</sql:query>
<c:if test="${hardwareQ.rows[0].name == 'NEW'}">
    <ta:setHardwareStatus hardwareId="${hardwareId}" hardwareStatusName="IN_PROGRESS" reason="First Process Traveler" activityId="${activityId}"/>
</c:if>
