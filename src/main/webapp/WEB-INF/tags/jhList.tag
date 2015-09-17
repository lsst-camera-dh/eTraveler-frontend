<%-- 
    Document   : jhList
    Created on : Sep 17, 2015, 1:49:21 PM
    Author     : focke
--%>

<%@tag description="List Job Harness installs" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>

<%@attribute name="siteId"%>

    <sql:query var="jhQ">
select JH.*, S.name as siteName
from JobHarness JH
inner join Site S on JH.siteId=S.id
<c:if test="${! empty siteId}">where S.id=?<sql:param value="${siteId}"/></c:if>
;
    </sql:query>

<display:table name="${jhQ.rows}" id="row" class="datatable" sort="list"
               pagesize="${fn:length(jhq.rows) > preferences.pageLength ? preferences.pageLength : 0}">
    <display:column property="name" sortable="true" headerClass="sortable"/>
    <display:column property="description" sortable="true" headerClass="sortable"/>
    <c:if test="${empty siteId or preferences.showFilteredColumns}">
        <display:column property="siteName" title="Site" sortable="true" headerClass="sortable"
                        href="displaySite.jsp" paramId="siteId" paramProperty="siteId"/>
    </c:if>
    <display:column property="jhVirtualEnv" sortable="true" headerClass="sortable"/>
    <display:column property="jhOutputRoot" sortable="true" headerClass="sortable"/>
    <display:column property="jhStageRoot" sortable="true" headerClass="sortable"/>
    <display:column property="jhCfg" sortable="true" headerClass="sortable"/>
    <display:column property="createdBy" title="Creator" sortable="true" headerClass="sortable"/>
    <display:column property="creationTS" title="Date" sortable="true" headerClass="sortable"/>
</display:table>