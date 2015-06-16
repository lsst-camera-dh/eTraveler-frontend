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
    select A.*, P.name, H.lsstId
    from Activity A
    inner join Process P on P.id=A.processId
    inner join Hardware H on H.id=A.hardwareId
    where A.id=?<sql:param value="${param.activityId}"/>;
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Activity <c:out value="${activity.name}"/></title>
    </head>
    <body>
        <c:set var="activityAutoCreate" value="true" scope="session"/>
        <traveler:expandActivity var="stepList" activityId="${param.activityId}"/>
        <traveler:findCurrentStep varStepLink="currentStepLink" varStepEPath="currentStepEPath" 
                                  varStepId="currentStepActivityId" stepList="${stepList}"/>

        <traveler:setPaths activityVar="activityPath" processVar="processPath" activityId="${param.activityId}"/>
<%--                  
        <table>
            <tr>
                <td>
        <h2>Process</h2>
        <traveler:processCrumbs processPath="${processPath}"/>
        <traveler:processWidget processId="${activity.processId}"/>
        
        <h2>Activity</h2>
        <traveler:activityCrumbs activityPath="${activityPath}"/>
        <traveler:activityHeader activityId="${param.activityId}"/>
                </td>
                <td>
        <h2>Component</h2>
        <traveler:hardwareHeader hardwareId="${activity.hardwareId}"/>
                </td>
            </tr>
        </table>
        <h2>Steps</h2>
--%>
<c:url var="hwLink" value="displayHardware.jsp"><c:param name="hardwareId" value="${activity.hardwareId}"/></c:url>
<h2>Process: <c:out value="${activity.name}"/> Component: <a href="${hwLink}"><c:out value="${activity.lsstId}"/></a></h2>
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
