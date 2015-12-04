<%-- 
    Document   : limsRunAutomatable
    Created on : Oct 15, 2015, 4:53:34 PM
    Author     : focke
--%>

<%@tag description="Run an automatable traveler from scripting API" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<traveler:findComponent var="hardwareId" serial="${inputs.experimentSN}"
                        inputId="${inputs.hardwareId}" groupName="${inputs.hardwareGroup}"
                        typeName="${inputs.htype}"/>

<traveler:findProcess var="processId" 
                      name="${inputs.travelerName}" version="${inputs.travelerVersion}"
                      hardwareGroup="${inputs.hardwareGroup}"/>

    <sql:query var="autoQ">
select travelerActionMask&(select maskBit from InternalAction where name='harnessedJob') as isHarnessed,
travelerActionMask&(select maskBit from InternalAction where name='automatable') as isAutomatable
from Process where id=?<sql:param value="${processId}"/>;
    </sql:query>
<c:set var="process" value="${autoQ.rows[0]}"/>
<c:if test="${process.isHarnessed==0 && process.isAutomatable==0}">
    <traveler:error message="Travler ${processId} is neither automatable ${process.isAutomatable} nor harnessed ${process.isHarnessed}."/>
</c:if>

    <sql:query var="jhQ">
select JH.id from JobHarness JH
inner join Site S on S.id=JH.siteId
where JH.name=?<sql:param value="${inputs.jhInstall}"/>
and S.name=?<sql:param value="${inputs.site}"/>
;
    </sql:query>
<c:if test="${empty jhQ.rows}">
    <traveler:error message="No job harness install with name=${inputs.jhInstall} and site=${inputs.site} found."/>
</c:if>
<c:set var="jhId" value="${jhQ.rows[0].id}"/>

<ta:createTraveler var="activityId"
                   processId="${processId}" hardwareId="${hardwareId}"
                   jobHarnessId="${jhId}"/>

<traveler:jhCommand var="command" varError="allOk" activityId="${activityId}"/>

<c:choose>
    <c:when test="${allOk}">
{"command": "${command}", "acknowledge": null}
    </c:when>
    <c:otherwise>
{"command": null, "acknowledge": "${command}"}
    </c:otherwise>
</c:choose>