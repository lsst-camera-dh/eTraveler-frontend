<%-- 
    Document   : satusfyPrereq
    Created on : Aug 1, 2013, 3:14:57 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <sql:transaction >
            <sql:update>
                insert into Prerequisite set
                prerequisitePatternId=?<sql:param value="${param.prerequisitePatternId}"/>,
                activityId=?<sql:param value="${param.activityId}"/>,
                <c:if test="${! empty param.prerequisiteActivityId}">
                    prerequisiteActivityId=?<sql:param value="${param.prerequisiteActivityId}"/>,
                </c:if>
                <c:if test="${! empty param.componentId}">
                    hardwareId=?<sql:param value="${param.componentId}"/>,
                </c:if>
                createdBy=?<sql:param value="${userName}"/>,
                creationTs=now();
            </sql:update>
            
            <c:if test="${! empty param.componentId}">
                <sql:update>
                    insert into HardwareRelationship set
                    hardwareId=?<sql:param value="${param.hardwareId}"/>,
                    componentId=?<sql:param value="${param.componentId}"/>,
                    hardwareRelationshipTypeId=?<sql:param value="${param.hardwareRelationshipTypeId}"/>,
                    createdBy=?<sql:param value="${userName}"/>,
                    creationTs=now();
                </sql:update>

                <sql:update>
                    update Activity set
                    hardwareRelationshipId=LAST_INSERT_ID()
                    where id=?<sql:param value="${param.activityId}"/>;
                </sql:update>

                <sql:update>
                    update Hardware set
                    hardwareStatusId=(select id from HardwareStatus where name='USED')
                    where id=?<sql:param value="${param.componentId}"/>;
                </sql:update>
                    
                <sql:update>
                    insert into HardwareStatusHistory set
                    hardwareStatusId=(select id from HardwareStatus where name='USED'),
                    hardwareId=?<sql:param value="${param.componentId}"/>,
                    createdBy=?<sql:param value="${userName}"/>,
                    creationTS=now();
                </sql:update>
            </c:if>
        </sql:transaction>
                
        <c:redirect url="${header.referer}"/>
    </body>
</html>
