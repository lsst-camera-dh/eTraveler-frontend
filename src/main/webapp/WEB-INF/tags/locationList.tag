<%-- 
    Document   : locationList
    Created on : Jan 7, 2015, 2:12:43 PM
    Author     : focke
--%>

<%@tag description="List Locations" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>

<sql:query var="locationQ">
    select L.*, S.name as siteName
    from Location L
    inner join Site S on S.id=L.siteId;
</sql:query>

<display:table name="${locationQ.rows}" class="datatable">
    <display:column property="name" sortable="true" headerClass="sortable"/>
    <display:column property="siteName" sortable="true" headerClass="sortable"/>
    <display:column property="createdBy" title="Creator" sortable="true" headerClass="sortable"/>
    <display:column property="creationTS" title="Date" sortable="true" headerClass="sortable"/>
</display:table>
