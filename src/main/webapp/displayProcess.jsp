<%-- 
    Document   : displayProcess
    Created on : Jan 31, 2013, 6:12:24 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<traveler:lastInPath var="processId" processPath="${param.processPath}"/>
<traveler:checkId table="Process" id="${processId}"/>

<sql:query var="processQ" >
    select P.*, TT.id as travelerTypeId, HG.name as hgName
    from Process P
    inner join HardwareGroup HG on HG.id=P.hardwareGroupId
    left join TravelerType TT on TT.rootProcessId=P.id
    where P.id=?<sql:param value="${processId}"/>;
</sql:query>
<c:set var="process" value="${processQ.rows[0]}"/>

        <!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Process <c:out value="${process.name}, ${process.shortDescription}"/></title>
    </head>
    <body>

        <table>
            <tr>
                <td>
        <h2>Process</h2>
        <traveler:processCrumbs processPath="${param.processPath}"/>
        
        <traveler:countSteps var="nSteps" processId="${processId}"/>
        ${nSteps} steps <br>
        
        <c:if test="${! empty process.travelerTypeId}">
            <c:url var="ttLink" value="displayTravelerType.jsp">
                <c:param name="travelerTypeId" value="${process.travelerTypeId}"/>
            </c:url>
            <a href="${ttLink}">Administer Traveler Type</a><br>
        </c:if>

        <traveler:processWidget processId="${processId}"/>
                </td>
                <td>
        <c:url var="hwGroupLink" value="displayHardwareGroup.jsp">
            <c:param name="hardwareGroupId" value="${process.hardwareGroupId}"/>
        </c:url>
        <h2>Component Group <a href="${hwGroupLink}"><c:out value="${process.hgName}"/></a></h2>
        <h2>Component types</h2>
        <traveler:hardwareTypeList hardwareGroupId="${process.hardwareGroupId}"/>
                </td>
            </tr>
        </table>

        <c:if test="${! empty process.travelerTypeId}">
        <h2>Instances</h2>
        Make a new instance: <traveler:newTravelerForm processId="${processId}" hardwareGroupId="${process.hardwareGroupId}"/>
        <traveler:activityList processId="${processId}"/>
        </c:if>
        
        <h2>Steps</h2>
        <traveler:expandProcess var="stepList" processId="${processId}"/>
        <table>
            <tr>
                <td style="vertical-align:top;">
                    <traveler:showStepsTable stepList="${stepList}" mode="process"/>
                </td>
                <td style="vertical-align:top;">
                    <c:url var="contentLink" value="processPane.jsp">
                        <c:param name="processId" value="${processId}"/>
                    </c:url>
                    <iframe name="content" src="${contentLink}" width="800" height="4000"></iframe>
                </td>
            </tr>
        </table>

        <traveler:newTravelerTypeForm processId="${processId}"/> 
    </body>
</html>
