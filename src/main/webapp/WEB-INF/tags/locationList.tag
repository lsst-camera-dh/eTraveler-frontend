<%-- 
    Document   : locationList
    Created on : Jan 7, 2015, 2:12:43 PM
    Author     : focke
--%>

<%@tag description="List Locations" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>

<%@attribute name="siteId"%>

<sql:query var="locationQ">
    select L.*, S.name as siteName, S.id as siteId
    from Location L
    inner join Site S on S.id=L.siteId
    where 1
    <c:if test="${! empty siteId}">
        and S.id=?<sql:param value="${siteId}"/>
    </c:if>
    ;
</sql:query>

<display:table name="${locationQ.rows}" class="datatable" sort="list"
               pagesize="${fn:length(locationQ.rows) > preferences.pageLength ? preferences.pageLength : 0}">
    <c:if test="${empty siteId or preferences.showFilteredColumns}">
        <display:column property="siteName" title="Site" sortable="true" headerClass="sortable"
                        href="displaySite.jsp" paramId="siteId" paramProperty="siteId"/>
    </c:if>
    <display:column property="name" sortable="true" headerClass="sortable"
                    href="displayLocation.jsp" paramId="locationId" paramProperty="id"/>
    <display:column property="createdBy" title="Creator" sortable="true" headerClass="sortable"/>
    <display:column property="creationTS" title="Date" sortable="true" headerClass="sortable"/>
</display:table>
