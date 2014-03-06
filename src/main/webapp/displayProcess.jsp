<%-- 
    Document   : displayProcess
    Created on : Jan 31, 2013, 6:12:24 PM
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
        <title>Process Dump</title>
    </head>
    <body>

        <traveler:lastInPath processPath="${param.processPath}"/>

        <table>
            <tr>
                <td>
        <h2>Process</h2>
        <traveler:processCrumbs processPath="${param.processPath}"/>

        <sql:query var="processQ" >
            select P.*
            from Process P
            where id=?<sql:param value="${processId}"/>;
        </sql:query>
        <c:set var="process" value="${processQ.rows[0]}"/>
        <traveler:processWidget processId="${processId}"/>
                </td>
                <td>

        <h2>Component type</h2>
        <traveler:hardwareTypeList hardwareTypeId="${process.hardwareTypeId}"/>
                </td>
            </tr>
        </table>

        <h2>Steps</h2>
        <table>
            <tr>
                <td style="vertical-align:top;">
                    <traveler:processTable processPath="${param.processPath}"/>
                </td>
                <td style="vertical-align:top;">
                    <c:url var="contentLink" value="processPane.jsp">
                        <c:param name="processId" value="${processId}"/>
                    </c:url>
                    <iframe name="content" src="${contentLink}" width="600" height="400"></iframe>
                </td>
            </tr>
        </table>

        <h2>Instances</h2>
        <traveler:activityList processId="${processId}"/>
        Make a new instance: <traveler:newTravelerForm processId="${processId}" hardwareTypeId="${process.hardwareTypeId}"/>
    </body>
</html>
