<%-- 
    Document   : getTravelerTypeStatus
    Created on : Apr 10, 2015, 5:55:45 PM
    Author     : focke
--%>

<%@tag description="Find the status of an ActivityTravelerType" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="travelerTypeId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="status" scope="AT_BEGIN"%>

    <sql:query var="statusQ">
select 
    TTS.id, TTS.name
from 
    TravelerTypeState TTS
    inner join TravelerTypeStateHistory TTSH on TTSH.travelerTypeStateId=TTS.id
where 
    TTSH.travelerTypeId=?<sql:param value="${travelerTypeId}"/>
order by
    TTSH.id desc limit 1
;
    </sql:query>
<c:set var="status" value="${statusQ.rows[0].name}"/>
