<%-- 
    Document   : jhCommand
    Created on : May 16, 2014, 1:51:21 PM
    Author     : focke
--%>

<%@tag description="Generate a command to run the job harness" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="command" scope="AT_BEGIN"%>
<%@attribute name="varError" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="varError" alias="allOk" scope="AT_BEGIN"%>

<c:set var="allOk" value="true"/>

<sql:query var="activityQ">
    select
    A.end,
    P.name as processName, P.userVersionString, P.jobName,
    P.travelerActionMask&(select maskBit from InternalAction where name='harnessedJob') as isHarnessed,
    P.travelerActionMask&(select maskBit from InternalAction where name='automatable') as isAutomatable,
    H.lsstId,
    HT.name as hardwareTypeName,
    JH.*
    from Activity A
    inner join Process P on P.id=A.processId
    inner join Hardware H on H.id=A.hardwareId
    inner join HardwareType HT on HT.id=H.hardwareTypeId
    inner join JobHarness JH on JH.id=A.jobHarnessId
    where A.id=?<sql:param value="${activityId}"/>
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<c:set var="binDir" value="${activity.jhVirtualEnv}/bin"/>
<c:set var="instDir" value="${activity.jhVirtualEnv}/share"/>

<c:choose>
    <c:when test="${! empty activity.jhCfg}">
        <c:set var="cfgBit" value="--config=${activity.jhCfg}"/>
    </c:when>
    <c:otherwise>
        <c:set var="cfgBit" value=""/>
    </c:otherwise>
</c:choose>

<c:choose>
    <c:when test="${! empty activity.jhStageRoot}">
        <c:set var="stageBit" value="--stage-root=${activity.jhStageRoot}"/>
    </c:when>
    <c:otherwise>
        <c:set var="stageBit" value=""/>
    </c:otherwise>
</c:choose>

<traveler:fullContext var="fullContext"/>
<c:url var="limsUrl" value="${fullContext}/${appVariables.dataSourceMode}"/>

<c:choose>
    <c:when test="${activity.isAutomatable != 0}">
        <c:set var="command" value="${binDir}/lcatr-iterator --container-id=${activityId} --lims-url=${limsUrl} --install-area=${instDir} ${stageBit} ${cfgBit}"/>
    </c:when>
    <c:when test="${activity.isHarnessed != 0}">
        <c:set var="command">${binDir}/lcatr-harness --unit-type=${activity.hardwareTypeName} --unit-id=${activity.lsstId} --job=${activity.jobName} --version=${activity.userVersionString} --lims-url=${limsUrl} --archive-root=${activity.jhOutputRoot} --install-area=${instDir} ${stageBit} ${cfgBit}</c:set>
    </c:when>
    <c:otherwise>
        <c:set var="allOk" value="false"/>
        <c:set var="command" value="Error: Process ${activity.processName} is neither automatable nor harnessed."/>
    </c:otherwise>
</c:choose>
