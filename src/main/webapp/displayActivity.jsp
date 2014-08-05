<%-- 
    Document   : displayActivity
    Created on : Jan 29, 2013, 5:09:56 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Activity</title>
    </head>
    <body>
        <c:set var="activityAutoCreate" value="true" scope="session"/>
        <traveler:stepList var="stepList" mode="activity" theId="${param.activityId}"/>
        <traveler:findCurrentStep varStepLink="currentStepLink" varStepEPath="currentStepEPath" 
                                  stepList="${stepList}"/>

        <traveler:checkId table="Activity" id="${param.activityId}"/>

        <traveler:setReturn extra="#theFold"/>
        <traveler:setPaths activityId="${param.activityId}"/>
        
        <sql:query var="activityQ" >
            select * from Activity where id=?<sql:param value="${param.activityId}"/>;
        </sql:query>
        <c:set var="activity" value="${activityQ.rows[0]}"/>
          
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
    <div id="theFold"/>        
        <table>
            <tr>
                <td style="vertical-align:top;">
<%--
                    <traveler:activityTable activityId="${param.activityId}"/>
                    <c:if test="${startNextStep}"><c:redirect url="${currentStepLink}"/></c:if>
--%>
                    <traveler:showStepsTable stepList="${stepList}" mode="activity"
                         currentStepLink="${currentStepLink}" currentStepEPath="${currentStepEPath}"/>                    
                </td>
                <td style="vertical-align:top;">
                    <iframe name="content" src="${currentStepLink}" width="600" height="400"></iframe>
                    <br>
                    <a href="${currentStepLink}" target="content">Current step</a>
                </td>
            </tr>
        </table>
    </body>
</html>
