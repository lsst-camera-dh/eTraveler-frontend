<%-- 
    Document   : hardwareStatusWidget
    Created on : Oct 31, 2013, 11:10:46 AM
    Author     : focke
--%>

<%@tag description="Display various stuff about a component's status" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="hardwareId" required="true"%>

<sql:query  var="statusHistoryQ">
    select HS.name, HSH.creationTS, HSH.createdBy
    from HardwareStatus HS
    inner join HardwareStatusHistory HSH on HS.id=HSH.hardwareStatusId
    where HSH.hardwareId=?<sql:param value="${hardwareId}"/>
    order by HSH.creationTS desc;
</sql:query>
<display:table name="${statusHistoryQ.rows}" class="datatable" pagesize="${preferences.pageLength}" sort="list">
    <display:column property="name" title="Staus"/>
    <display:column property="creationTS" title="When"/>
    <display:column property="createdBy" title="Who"/>
</display:table>


<traveler:hardwareStatusForm hardwareId="${param.hardwareId}"/>
