<%-- 
    Document   : createActivity
    Created on : Jan 29, 2013, 11:12:46 AM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>JSP Page</title>
    </head>
    <body>
        <sql:query var="processQ" dataSource="jdbc/rd-lsst-cam">
            select * from Process where id=?<sql:param value="${param.processId}"/>
        </sql:query>
        <c:set var="process" value="${processQ.rows[0]}"/>
        <sql:transaction dataSource="jdbc/rd-lsst-cam">
            <c:if test="${! empty param.componentId}">
                <sql:update>
                    insert into HardwareRelationship set
                    hardwareId=?<sql:param value="${param.hardwareId}"/>,
                    componentId=?<sql:param value="${param.componentId}"/>,
                    hardwareRelationshipTypeId=?<sql:param value="${process.hardwareRelationshipTypeId}"/>,
                    createdBy=?<sql:param value="${userName}"/>,
                    creationTS=NOW();
                </sql:update>
                <sql:query var="relationshipQ">
                    select * from HardwareRelationship where id=LAST_INSERT_ID();
                </sql:query>
                <c:set var="relationship" value="${relationshipQ.rows[0]}"/>
                <c:set var="relationShipId" value="${relationship.id}"/>
            </c:if>
            <sql:update>
                insert into Activity set
                hardwareId=?<sql:param value="${param.hardwareId}"/>,
                hardwareRelationshipId=?<sql:param value="${relationShipId}"/>,
                processId=?<sql:param value="${param.processId}"/>,
                processEdgeId=?<sql:param value="${param.processEdgeId}"/>,
                parentActivityId=?<sql:param value="${param.parentActivityId}"/>,
                begin=NOW(),
                inNCR=?<sql:param value="${param.inNCR}"/>,
                createdBy=?<sql:param value="${userName}"/>,
                creationTS=NOW();
           </sql:update>
<%--
           <sql:query var="activityQ">
               select * from Activity where id=LAST_INSERT_ID()                
           </sql:query>
--%>
        </sql:transaction>
<%--
        <c:redirect url="displayActivity.jsp">
            <c:param name="activityId" value="${activityQ.rows[0]['id']}"/>
        </c:redirect>
--%>
        <c:redirect url="${header.referer}"/>
    </body>
</html>
