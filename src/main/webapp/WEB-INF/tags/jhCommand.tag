<%-- 
    Document   : jhCommand
    Created on : May 16, 2014, 1:51:21 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="command" scope="AT_BEGIN"%>

<sql:query var="activityQ">
    select
    A.end,
    P.name as processName, P.userVersionString,
    H.lsstId,
    HT.name as hardwareTypeName
    from Activity A
    inner join Process P on P.id=A.processId
    inner join Hardware H on H.id=A.hardwareId
    inner join HardwareType HT on HT.id=H.hardwareTypeId
    where A.id=?<sql:param value="${activityId}"/>
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>
        
<c:set var="command">lcatr-harness --unit-type ${activity.hardwareTypeName} --unit-id ${activity.lsstId} --job ${activity.processName} --version ${activity.userVersionString}</c:set>
