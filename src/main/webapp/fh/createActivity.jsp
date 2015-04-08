<%-- 
    Document   : createActivity
    Created on : Jan 30, 2013, 2:22:04 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Create Activity</title>
    </head>
    <body>
        <c:set var="allOk" value="true"/>
        <c:set var="message" value="Tell the developers you ran into bug #282805"/>
        
        <%-- If this process uninstalls a component, find the relationship to break --%>
        <c:if test="${allOk}">
            <sql:query var="breakHRQ">
                select P.travelerActionMask&(select maskBit from InternalAction where name='breakHardwareRelationship') as breaksRelationship
                from Process P
                where P.id=?<sql:param value="${param.processId}"/>;
            </sql:query>
            <c:if test="${breakHRQ.rows[0].breaksRelationship != 0}">
                <sql:query var="hrQ">
                    select
                    P.name as processName,
                    H.lsstId,
                    HRT.name,
                    HR.id
                    from
                    Process P
                    cross join Hardware H
                    inner join HardwareRelationshipType HRT on HRT.id=P.hardwareRelationshipTypeId
                    left join HardwareRelationship HR on HR.hardwareRelationshipTypeId=HRT.id and HR.hardwareId=H.id
                    where
                    P.id=?<sql:param value="${param.processId}"/>
                    and H.id=?<sql:param value="${param.hardwareId}"/>
                    and HR.end is null;
                </sql:query>
                <c:choose>
                    <c:when test="${fn:length(hrQ.rows) != 1}">
                        <c:set var="allOk" value="false"/>
                        <c:set var="message" value="Bug #606136 ${fn:length(hrQ.rows)}"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="relation" value="${hrQ.rows[0]}"/>
                        <c:choose>
                            <c:when test="${empty relation.id}">
                                <c:set var="allOk" value="false"/>
                                <c:set var="message" value="Process ${relation.processName} is supposed to break a relationship of type ${relation.name}, but none exists for component ${relation.lsstId}."/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="relationToBreak" value="${relation.id}"/>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </c:if>
        </c:if>
        
        <c:choose>
            <c:when test="${allOk}">
<sql:transaction>
                <ta:createActivity hardwareId="${param.hardwareId}" processId="${param.processId}"
                    parentActivityId="${param.parentActivityId}" processEdgeId="${param.processEdgeId}"
                    inNCR="${param.inNCR}" hardwareRelationshipId="${relationToBreak}"
                    var="newActivityId"/>
</sql:transaction>

                <traveler:redirDA/>
            </c:when>
            <c:otherwise>
                <c:out value="${message}"/>
            </c:otherwise>
        </c:choose>
    </body>
</html>
