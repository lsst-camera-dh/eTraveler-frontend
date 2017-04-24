<%-- 
    Document   : genericLabelTable
    Created on : Nov 15, 2016, 10:48 AM
    Author     : jrb
--%>

<%@tag description="show a table of component states or labels" pageEncoding="UTF-8"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>

<%@attribute name="result" required="true" type="javax.servlet.jsp.jstl.sql.Result"%>

<display:table name="${result.rows}" class="datatable" sort="list"
               pagesize="${fn:length(result.rows) > preferences.pageLength ? preferences.pageLength : 0}">
    <display:column property="labelName" title="Name" sortable="true" headerClass="sortable"/>
    <display:column property="reason" title="Reason" sortable="true" headerClass="sortable"/>
    <display:column property="processName" title="Step" sortable="true" headerClass="sortable"
                    href="displayActivity.jsp" paramId="activityId" paramProperty="activityId"/>
    <display:column property="creationTS" title="Date" sortable="true" headerClass="sortable"/>
    <display:column property="createdBy" title="User" sortable="true" headerClass="sortable"/>
</display:table>

