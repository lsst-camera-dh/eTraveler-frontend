<%-- 
    Document   : addStandaloneExceptions
    Created on : Apr 6, 2017, 4:52:39 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>

<c:if test="${userName != 'focke'}">
    <traveler:error message="Nope."/>
</c:if>
        
    <sql:query var="ncrQ">
select A.id as activityId, ET.id as exceptionTypeId
from Activity A
left join ExceptionType ET on ET.exitProcessId = A.processId
left join Exception E on E.NCRActivityId = A.id
where A.parentActivityId is null
and A.inNCR = 'TRUE'
and E.id is null
    </sql:query>

<display:table name="${ncrQ.rows}" class="datatable"/>

<c:if test="${param.doIt == 'yesPlease'}">
    <sql:transaction>
       <c:forEach var="ncr" items="${ncrQ.rows}">
            <sql:update>
insert into Exception set
exceptionTypeId = ?<sql:param value="${ncr.exceptionTypeId}"/>,
exitActivityId = ?<sql:param value="${ncr.activityId}"/>,
NCRActivityId = ?<sql:param value="${ncr.activityId}"/>,
createdBy = ?<sql:param value="${userName}"/>,
creationTS = utc_timestamp()
            </sql:update>
        </c:forEach>
    </sql:transaction>
</c:if>

    </body>
</html>
