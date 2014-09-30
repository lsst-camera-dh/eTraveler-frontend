<%-- 
    Document   : stepTest
    Created on : Jul 24, 2014, 12:01:35 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Step Test</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <c:set var="activityAutoCreate" value="true" scope="session"/>
            <sql:query var="aQ">
select * from Activity where id=?<sql:param value="${param.activityId}"/>
            </sql:query>
            <traveler:expandActivity activityId="${param.activityId}" var="acList"/>
            <traveler:expandProcess processId="${aQ.rows[0].processId}" var="procList"/>
            <table border=1">
                <tr>
                    <td>
                        <traveler:showStepsTable stepList="${procList}" mode="process"/>
                    </td>
                    <td>
                        <traveler:findCurrentStep varStepLink="currentStepLink" varStepEPath="currentStepEPath" 
                          stepList="${acList}"/>
                        <traveler:showStepsTable stepList="${acList}" mode="activity"
                         currentStepLink="${currentStepLink}" currentStepEPath="${currentStepEPath}"/>
                    </td>
                    <td>
                        <a href="${currentStepLink}" target="content">Go to current step</a><br>
                        <iframe name="content" src="${currentStepLink}" width="600" height="400"/>
                    </td>
                </tr>
                <%--
                <tr>
                    <td>
<traveler:stepList var="stepList" mode="process" theId="${aQ.rows[0].processId}"/>
<traveler:showStepsTable stepList="${stepList}" mode="process"/>
                    </td>
                    <td>
<traveler:stepList var="stepList" mode="activity" theId="${param.activityId}"/>
<traveler:findCurrentStep varStepLink="currentStepLink" varStepEPath="currentStepEPath" 
                          stepList="${stepList}"/>
<traveler:showStepsTable stepList="${stepList}" mode="activity"
                         currentStepLink="${currentStepLink}" currentStepEPath="${currentStepEPath}"/>
                    </td>
                    <td>
                        <a href="${currentStepLink}" target="content">Go to current step</a><br>
                        <iframe name="content" src="${currentStepLink}" width="600" height="400"/>
                    </td>
                </tr>
                --%>
            </table>
    </body>
</html>
