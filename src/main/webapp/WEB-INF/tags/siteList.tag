<%-- 
    Document   : siteList
    Created on : Jan 7, 2015, 2:12:43 PM
    Author     : focke
--%>

<%@tag description="List Sites" pageEncoding="UTF-8"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>

    <sql:query var="siteQ">
select
    S.*,
    count(distinct L.id) as nLocations, count(distinct H.id) as nComponents
from
    Site S
    left join Location L on L.siteId=S.id
    left join (Hardware H inner join HardwareLocationHistory HLH on HLH.hardwareId=H.id
                and HLH.id=(select max(id) from HardwareLocationHistory where hardwareId=H.id))
               on HLH.locationId=L.id

group by S.id
order by S.name;
    </sql:query>

<display:table name="${siteQ.rows}" class="datatable" sort="list"
               pagesize="${fn:length(siteQ.rows) > preferences.pageLength ? preferences.pageLength : 0}">
    <display:column property="name" sortable="true" headerClass="sortable"
                    href="displaySite.jsp" paramId="siteId" paramProperty="id"/>
    <display:column property="nLocations" title="# Locations" sortable="true" headerClass="sortable"/>
    <display:column property="nComponents" title="# Components" sortable="true" headerClass="sortable"/>
    <display:column property="createdBy" title="Creator" sortable="true" headerClass="sortable"/>
    <display:column property="creationTS" title="Date" sortable="true" headerClass="sortable"/>
</display:table>
