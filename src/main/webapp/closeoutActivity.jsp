<%-- 
    Document   : closeoutActivity
    Created on : Jan 30, 2013, 8:14:38 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Closeout Activity</title>
    </head>
    <body>

        <sql:transaction dataSource="jdbc/rd-lsst-cam">
            <sql:update >
                update Activity set 
                activityFinalStatusId=(select id from ActivityFinalStatus where name='success'),
                end=now(), 
                closedBy=?<sql:param value="${userName}"/>
                where 
                id=?<sql:param value="${param.activityId}"/>;
            </sql:update>
            <sql:query var="activityQ">
                select * from Activity where id=?<sql:param value="${param.activityId}"/>;
            </sql:query>
            <c:set var="activity" value="${activityQ.rows[0]}"/>
            <c:if test="${! empty activity.hardwareRelationshipId}">
                <sql:update>
                    update HardwareRelationship set 
                    begin=?<sql:param value="${activity.end}"/>
                    where 
                    id=?<sql:param value="${activity.hardwareRelationshipId}"/>;
                </sql:update>
            </c:if>
        </sql:transaction>
        <c:redirect url="displayActivity.jsp">
            <c:param name="activityId" value="${param.topActivityId}"/>
        </c:redirect>
<%--        <c:redirect url="${header.referer}"/>--%>
    </body>
</html>
