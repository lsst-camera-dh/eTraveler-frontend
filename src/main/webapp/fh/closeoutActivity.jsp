<%-- 
    Document   : closeoutActivity
    Created on : Jan 30, 2013, 8:14:38 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Closeout Activity</title>
    </head>
    <body>

        <sql:transaction >
            <sql:update >
                update Activity set 
                activityFinalStatusId=(select id from ActivityFinalStatus where name='success'),
                end=UTC_TIMESTAMP(), 
                closedBy=?<sql:param value="${userName}"/>
                where 
                id=?<sql:param value="${param.activityId}"/>;
            </sql:update>
            <sql:query var="activityQ">
                select A.*, 
                P.travelerActionMask&(select maskBit from InternalAction where name='makeHardwareRelationship') as makesRelationship,
                P.travelerActionMask&(select maskBit from InternalAction where name='breakHardwareRelationship') as breaksRelationship
                from Activity A
                inner join Process P on P.id=A.processId
                where A.id=?<sql:param value="${param.activityId}"/>;
            </sql:query>
            <c:set var="activity" value="${activityQ.rows[0]}"/>
            <c:if test="${activity.makesRelationShip != 0}">
                <sql:update>
                    update HardwareRelationship set 
                    begin=?<sql:param value="${activity.end}"/>
                    where 
                    id=?<sql:param value="${activity.hardwareRelationshipId}"/>;
                </sql:update>
            </c:if>
            <c:if test="${activity.breaksRelationship != 0}">
                <sql:update>
                    update HardwareRelationship set 
                    end=?<sql:param value="${activity.end}"/>
                    where 
                    id=?<sql:param value="${activity.hardwareRelationshipId}"/>;
                </sql:update>
            </c:if>
        </sql:transaction>
        
        <c:if test="${activity.inNCR && empty activity.parentActivityId}">
            <c:url var="ncrUrl" value="finishNCR.jsp">
                <c:param name="activityId" value="${param.activityId}"/>
            </c:url>
            <c:redirect url="${ncrUrl}"/>
        </c:if>
                    
        <traveler:redirDA/>
    </body>
</html>
