<%-- 
    Document   : limsScript
    Created on : Aug 8, 2014, 10:52:34 AM
    Author     : focke
--%>

<%@tag description="Supply the next command for scripted sequences." pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<c:set var="allOk" value="true"/>
<c:set var="message" value="Error #681399"/>

<c:if test="${allOk}">
    <traveler:getActivityStatus var="status" varFinal="isFinal" activityId="${inputs.containerid}"/>
    <c:choose>
        <c:when test="${status == 'new'}">
            <ta:startActivity activityId="${inputs.containerid}"/>
        </c:when>
        <c:when test="${status == 'inProgress'}"></c:when>
        <c:otherwise>
            <traveler:error message="Bad iterator status. 550581"/>
        </c:otherwise>
    </c:choose>
</c:if>

<c:if test="${allOk}">
    <traveler:expandActivity var="stepList" activityId="${inputs.containerid}"/>
</c:if>

<c:if test="${allOk}">
    <traveler:findCurrentStep stepList="${stepList}" scriptMode="true"
        varStepLink="junk" varStepEPath="edgePath" varStepId="childActivityId"/>
    <c:set var="done" value="${childActivityId == inputs.containerid}"/>
</c:if>

<c:if test="${allOk}"><c:choose>
    <c:when test="${done}">
        <ta:closeoutActivity activityId="${inputs.containerid}"/>
    </c:when>
    <c:otherwise>

        <c:if test="${allOk}">
            <sql:query var="historyQ">
select count(id) as count from JobStepHistory where activityId=?<sql:param value="${childActivityId}"/>;
            </sql:query>
            <c:if test="${historyQ.rows[0].count != 0}">
                <c:set var="allOk" value="false"/>
                <c:set var="message" value="Job Harness already running."/>        
            </c:if>
        </c:if>

        <c:if test="${allOk}">
            <traveler:autoProcessPrereq var="gotAllPrereqs" activityId="${childActivityId}"/>
            <c:if test="${! gotAllPrereqs}">
                <c:set var="allOk" value="false"/>
                <c:set var="message" value="Prereqs not satisfied."/>
            </c:if>
        </c:if>

        <c:if test="${allOk}">
            <ta:startActivity activityId="${childActivityId}"/>
        </c:if>

        <c:if test="${allOk}">
            <traveler:jhCommand var="jhCommand" varError="allOk" activityId="${childActivityId}"/>
        </c:if>

    </c:otherwise>
</c:choose></c:if>

<c:choose>
    <c:when test="${! allOk}">
        <c:set var="status" value="ERROR"/>
        <c:set var="command" value="${message}"/>
    </c:when>
    <c:when test="${done}">
        <c:set var="status" value="DONE"/>
        <c:set var="command" value=""/>
    </c:when>
    <c:otherwise>
        <c:set var="status" value="CMD"/>
        <c:set var="command" value="${jhCommand}"/>
    </c:otherwise>
</c:choose>

{
    "status": "<c:out value="${status}"/>",
    "command": "<c:out value="${command}"/>"
}
