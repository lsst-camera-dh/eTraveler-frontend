<%-- 
    Document   : newLabelTypeForm
    Created on : Mar 22, 2016, 6:10:37 PM
    Author     : focke
--%>

<%@tag description="Show available labels and add new ones" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<traveler:fullRequestString var="thisPage"/>
<traveler:checkPerm var="mayAdmin" groups="EtravelerAllAdmin"/>

<form action="admin/addLabelType.jsp">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
    <input type="hidden" name="referringPage" value="${thisPage}">
    Name: <input name="name">
    Description: <input name="description">
    <input type="submit" value="Add New Label Type"
           <c:if test="${! mayAdmin}">disabled</c:if>>
</form>

<sql:query var="labelsQ">
    select * from HardwareStatus where isStatusValue=0 order by name;
</sql:query>
<display:table name="${labelsQ.rows}" class="datatable" sort="list"
               pagesize="${fn:length(labelsQ.rows) > preferences.pageLength ? preferences.pageLength : 0}">
    <display:column property="name" title="Name" sortable="true" headerClass="sortable"/>
    <display:column property="description" title="Description" sortable="true" headerClass="sortable"/>
    <display:column property="systemEntry" title="System Supplied" sortable="true" headerClass="sortable"/>
    <display:column property="creationTS" title="Date" sortable="true" headerClass="sortable"/>
    <display:column property="createdBy" title="User" sortable="true" headerClass="sortable"/>
</display:table>
