<%-- 
    Document   : displayActivity
    Created on : Jan 29, 2013, 5:09:56 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<traveler:checkId table="Activity" id="${param.activityId}"/>
<sql:query var="activityQ" >
    select A.*, P.name, P.shortDescription, H.lsstId, JH.name as jhName, S.name as siteName
    from Activity A
    inner join Process P on P.id=A.processId
    inner join Hardware H on H.id=A.hardwareId
    left join JobHarness JH
        inner join Site S on S.id = JH.siteId
        on JH.id = A.jobHarnessId
    where A.id=?<sql:param value="${param.activityId}"/>;
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Activity <c:out value="${activity.name}, ${activity.shortDescription}"/></title>
    </head>
    <body>
        <traveler:expandActivity var="stepList" activityId="${param.activityId}"/>
        <traveler:findCurrentStep varStepLink="currentStepLink" varStepEPath="currentStepEPath" 
                                  varStepId="currentStepActivityId" stepList="${stepList}"/>

        <traveler:setPaths activityVar="activityPath" processVar="processPath" activityId="${param.activityId}"/>
        <traveler:activityCrumbs activityPath="${activityPath}"/>

<c:url var="hwLink" value="displayHardware.jsp"><c:param name="hardwareId" value="${activity.hardwareId}"/></c:url>
<h2>Process: <c:out value="${activity.name}"/> Component: <a href="${hwLink}"><c:out value="${activity.lsstId}"/></a></h2>

<h2>
<c:choose>
    <c:when test="${activity.inNCR}">
        NCR
    </c:when>
    <c:otherwise>
        Traveler
    </c:otherwise>
</c:choose>
ID ${activity.rootActivityId}
</h2>

<traveler:findRun varRun="runNumber" varTraveler="runTravelerId" activityId="${param.activityId}"/>
<c:choose>
    <c:when test="${runTravelerId == param.activityId}">
        <c:set var="runText" value="${runNumber}"/>
        <h2>Generic Labels</h2>
        <sql:query var="runQ">
            select id from RunNumber where rootActivityId = ?<sql:param value="${param.activityId}"/>
        </sql:query>
	<traveler:genericLabelWidget objectId="${runQ.rows[0].id}"
                                     objectTypeName="run" />
        
    </c:when>
    <c:otherwise>
        <c:url var="runLink" value="displayActivity.jsp">
            <c:param name="activityId" value="${runTravelerId}"/>
        </c:url>
        <c:set var="runText" value="<a href='${runLink}'>${runNumber}</a>"/>
    </c:otherwise>
</c:choose>
<h2>Run Number: ${runText}</h2>
<traveler:ncrWidget activityId="${param.activityId}"/>

<c:if test="${! empty activity.jhName}">
    <h3>Job Harness: <c:out value="${activity.siteName}"/> <c:out value="${activity.jhName}"/></h3>
</c:if>

    <div id="theFold"/>
        <table>
            <tr>
                <td style="vertical-align:top;">
                    <traveler:showStepsTable stepList="${stepList}" mode="activity"
                         currentStepLink="${currentStepLink}" currentStepEPath="${currentStepEPath}"
                         currentStepActivityId="${currentStepActivityId}"/>
                </td>
                <td style="vertical-align:top;">
                    <a href="${currentStepLink}" target="content">Return to current step</a>
                    <br>
                    <iframe name="content" src="${currentStepLink}" width="800" height="4000"></iframe>
                </td>
            </tr>
        </table>

    </body>
</html>
