<%-- 
    Document   : startActivity
    Created on : Aug 8, 2014, 1:16:56 PM
    Author     : focke
--%>

<%@tag description="Start an existing Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="activityId" required="true"%>

<ta:setActivityStatus activityId="${activityId}" status="inProgress"/>

    <sql:query var="activityQ">
select P.substeps
from Activity A
inner join Process P on P.id=A.processId
where A.id=?<sql:param value="${activityId}"/>
;
    </sql:query>

<c:if test="${initParam['activityAutoCreate']}">
    <c:choose>
        <c:when test="${activityQ.rows[0].substeps == 'SEQUENCE'}">
            <traveler:expandActivity var="stepList" activityId="${activityId}"/>
            <traveler:findCurrentStep scriptMode="true" stepList="${stepList}"
                                      varStepId="stepId"
                                      varStepEPath="stepEPath"
                                      varStepLink="stepLink"/>
        </c:when>
        <c:when test="${activityQ.rows[0].substeps == 'HARDWARE_SELECTION'}">
            <ta:hardwareSelect activityId="${activityId}"/>
        </c:when>
    </c:choose>
</c:if>