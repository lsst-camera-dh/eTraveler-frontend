<%-- 
    Document   : hardwareStatusWidget
    Created on : Oct 31, 2013, 11:10:46 AM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="hardwareId" required="true"%>

<sql:query dataSource="jdbc/rd-lsst-cam" var="statusHistoryQ">
    select HS.name, HSH.creationTS, HSH.createdBy
    from HardwareStatus HS
    inner join HardwareStatusHistory HSH on HS.id=HSH.hardwareStatusId
    where HSH.hardwareId=?<sql:param value="${hardwareId}"/>
    order by HSH.creationTS desc limit 10
</sql:query>
<display:table name="${statusHistoryQ.rows}" class="datatable">
    <display:column property="name" title="Staus"/>
    <display:column property="creationTS" title="When"/>
    <display:column property="createdBy" title="Who"/>
</display:table>


<traveler:hardwareStatusForm hardwareId="${param.hardwareId}"/>
