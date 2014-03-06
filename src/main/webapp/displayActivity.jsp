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
        <traveler:setReturn extra="#belowTheFold"/>
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
        <traveler:activityWidget activityId="${param.activityId}"/>
                </td>
                <td>
        <h2>Component</h2>
        <traveler:hardwareHeader hardwareId="${activity.hardwareId}"/>
                </td>
            </tr>
        </table>
                <div id="belowTheFold">        
        <h2>Steps</h2>
        <table>
            <tr>
                <td style="vertical-align:top;">
                    <traveler:activityTable activityId="${param.activityId}"/>
                    <c:if test="${startNextStep}"><c:redirect url="${currentStepLink}"/></c:if>
                    <a href="${currentStepLink}" target="content">Current step</a>
                </td>
                <td style="vertical-align:top;">
                    <iframe name="content" src="${currentStepLink}" width="600" height="400"></iframe>
                </td>
            </tr>
        </table>
                </div>
    </body>
</html>
