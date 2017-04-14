<%-- 
    Document   : addStandaloneExceptionTypes
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
select P.id as processId, TT.id as travelerTypeId
from Process P
inner join TravelerType TT on TT.rootProcessId = P.id
left join ExceptionType ET on ET.NCRProcessId = P.id
        and ET.exitProcessId = P.id
where P.name = 'NCR'
and ET.id is null
    </sql:query>

<display:table name="${ncrQ.rows}" class="datatable"/>

<c:if test="${param.doIt == 'yesPlease'}">
    <sql:transaction>
        <c:forEach var="ncr" items="${ncrQ.rows}">
            <sql:update>
update TravelerType set standaloneNCR = 1 where id = ?<sql:param value="${ncr.travelerTypeId}"/>
            </sql:update>
            <sql:update>
insert into ExceptionType set
conditionString = 'Standalone',
exitProcessId = ?<sql:param value="${ncr.processId}"/>,
rootProcessId = ?<sql:param value="${ncr.processId}"/>,
NCRProcessId = ?<sql:param value="${ncr.processId}"/>,
returnProcessId = ?<sql:param value="${ncr.processId}"/>,
createdBy = ?<sql:param value="${userName}"/>,
creationTS = utc_timestamp()
            </sql:update>
        </c:forEach>
    </sql:transaction>
</c:if>
    </body>
</html>
