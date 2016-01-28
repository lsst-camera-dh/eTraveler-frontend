<%-- 
    Document   : addTravelerType
    Created on : Dec 3, 2014, 2:56:08 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Traveler Type</title>
    </head>
    <body>
        <traveler:checkSsPerm var="mayAdmin" subsystemId="${param.subsystemId}" roles="admin"/>
        <c:if test="${! mayAdmin}">
            <sql:query var="subsysQ">
select name from Subsystem where id=?<sql:param value="${param.subsystemId}"/>;
            </sql:query>
            <traveler:error message="This operation requires admin priviledge for subsystem ${subsysQ.rows[0].name}."/>
        </c:if>
        
        <sql:query var="processQ">
select id from Process where id=?<sql:param value="${param.rootProcessId}"/>;
        </sql:query>
        
<c:choose>
    <c:when test="${empty processQ.rows}">
Error: Process <c:out value="${param.rootProcessId}"/> does not exist!
    </c:when>
    <c:otherwise>
        
<sql:transaction>        
    <sql:update>
insert into TravelerType set
rootProcessId=?<sql:param value="${param.rootProcessId}"/>,
owner=?<sql:param value="${param.owner}"/>,
reason=?<sql:param value="${param.reason}"/>,
subsystemId=?<sql:param value="${param.subsystemId}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=UTC_TIMESTAMP();
    </sql:update>
    <sql:query var="ttQ">
        select last_insert_id() as id;
    </sql:query>
    <c:set var="travelerTypeId" value="${ttQ.rows[0].id}"/>
    <sql:update>
insert into TravelerTypeStateHistory set
reason='New Traveler Type',
travelerTypeId=?<sql:param value="${travelerTypeId}"/>,
travelerTypeStateId=(select id from TravelerTypeState where name='new'),
createdBy=?<sql:param value="${userName}"/>,
creationTS=utc_timestamp();
    </sql:update>

<c:url var="ttLink" value="/displayTravelerType.jsp" context="/">
    <c:param name="travelerTypeId" value="${travelerTypeId}"/>
</c:url>
</sql:transaction>
        <c:redirect url="${ttLink}"/>
    </c:otherwise>
</c:choose>
    </body>
</html>
