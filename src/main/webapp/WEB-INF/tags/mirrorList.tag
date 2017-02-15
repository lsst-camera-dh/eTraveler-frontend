<%-- 
    Document   : siteList
    Created on : Jan 7, 2015, 2:12:43 PM
    Author     : focke
--%>

<%@tag description="List Sites" pageEncoding="UTF-8"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>

    <sql:query var="mirrorQ">
select *
from MirrorTask
order by name;
    </sql:query>

<display:table name="${mirrorQ.rows}" class="datatable" sort="list"
               pagesize="${fn:length(mirrorQ.rows) > preferences.pageLength ? preferences.pageLength : 0}">
    <display:column property="name" sortable="true" headerClass="sortable"/>
    <display:column property="sourceDirectory" title="Source Directory" sortable="true" headerClass="sortable"/>
    <display:column property="dcSite" title="Data Catalog Site" sortable="true" headerClass="sortable"/>
    <display:column property="createdBy" title="Creator" sortable="true" headerClass="sortable"/>
    <display:column property="creationTS" title="Date" sortable="true" headerClass="sortable"/>
</display:table>
