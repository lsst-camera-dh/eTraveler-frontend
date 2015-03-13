<%-- 
    Document   : siteList
    Created on : Jan 7, 2015, 2:12:43 PM
    Author     : focke
--%>

<%@tag description="List Sites" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>

<sql:query var="siteQ">
    select * from Site;
</sql:query>

<display:table name="${siteQ.rows}" class="datatable">
    <display:column property="name" sortable="true" headerClass="sortable"/>
    <display:column property="jhVirtualEnv" sortable="true" headerClass="sortable"/>
    <display:column property="jhOutputRoot" sortable="true" headerClass="sortable"/>
    <display:column property="createdBy" title="Creator" sortable="true" headerClass="sortable"/>
    <display:column property="creationTS" title="Date" sortable="true" headerClass="sortable"/>
</display:table>
