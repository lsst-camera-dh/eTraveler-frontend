<%-- 
    Document   : travelerTypeHistory
    Created on : Apr 17, 2015, 1:45:18 PM
    Author     : focke
--%>

<%@tag description="Show the state history of a TravelerType" pageEncoding="UTF-8"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>

<%@attribute name="travelerTypeId" required="true"%>

    <sql:query var="historyQ">
select
    TTSH.*,
    TTS.name
from
    TravelerTypeStateHistory TTSH
    inner join TravelerTypeState TTS on TTS.id=TTSH.travelerTypeStateId
where
    TTSH.travelerTypeId=?<sql:param value="${travelerTypeId}"/>
order by
    TTSH.id desc
;
    </sql:query>

<display:table name="${historyQ.rows}" class="datatable" sort="list"
               pagesize="${fn:length(historyQ.rows) > preferences.pageLength ? preferences.pageLength : 0}">
    <display:column property="name" title="State" sortable="true" headerClass="sortable"/>
    <display:column property="reason" title="Why" sortable="true" headerClass="sortable"/>
    <display:column property="createdBy" title="Who" sortable="true" headerClass="sortable"/>
    <display:column property="creationTS" title="When" sortable="true" headerClass="sortable"/>
</display:table>