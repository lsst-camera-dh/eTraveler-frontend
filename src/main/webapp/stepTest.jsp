<%-- 
    Document   : stepTest
    Created on : Jul 24, 2014, 12:01:35 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
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
            <sql:query var="aQ">
select * from Activity where id=?<sql:param value="${param.activityId}"/>
            </sql:query>
            <table>
                <tr>
                    <td>
<traveler:stepList var="stepList" mode="process" theId="${aQ.rows[0].processId}"/>
<display:table name="${stepList}" class="datatable">
    <display:column property="processId"/>
    <display:column property="stepPath"/>
    <display:column property="edgePath"/>
    <display:column property="processPath"/>
    <display:column property="name"/>
</display:table>
                    </td>
                    <td>
<traveler:stepList var="stepList" mode="activity" theId="${param.activityId}"/>
<display:table name="${stepList}" class="datatable">
    <display:column property="activityId"/>
    <display:column property="processId"/>
    <display:column property="stepPath"/>
    <display:column property="edgePath"/>
    <display:column property="processPath"/>
    <display:column property="name"/>
</display:table>
                    </td>
                </tr>
            </table>
    </body>
</html>
