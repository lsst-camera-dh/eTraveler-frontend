<%-- 
    Document   : subsystemList
    Created on : Jan 8, 2016, 4:50:37 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="subsystemId"%>
<%@attribute name="mode"%>

<c:choose>
    <c:when test="${! empty subsystemId and mode != 'p' and mode != 'c'}">
        <traveler:error message="Bad mode ${mode} in subsystem list." bug="true"/>
    </c:when>
    <c:when test="${empty subsystemId and ! empty mode}">
        <traveler:error message="Empty id in subsystem list." bug="true"/>
    </c:when>
</c:choose>

    <sql:query var="result">
select * from Subsystem
<c:choose>
    <c:when test="${mode == 'p'}">
where id=(select parentId from Subsystem where id=?<sql:param value="${subsystemId}"/>)
    </c:when>
    <c:when test="${mode == 'c'}">
where parentId=?<sql:param value="${subsystemId}"/>
    </c:when>
</c:choose>
;
    </sql:query>

<c:if test="${! empty result.rows}">
    
    <c:choose>
        <c:when test="${mode == 'p'}">
            <h2>Parent</h2>
        </c:when>
        <c:when test="${mode == 'c'}">
            <h2>Children</h2>
        </c:when>
    </c:choose>

<display:table name="${result.rows}" id="row" class="datatable" sort="list"
               pagesize="${fn:length(result.rows) > preferences.pageLength ? preferences.pageLength : 0}">
    <display:column property="name" title="Name" sortable="true" headerClass="sortable"
                    href="displaySubsystem.jsp" paramId="subsystemId" paramProperty="id"/>    
    <display:column property="shortName" title="Short Name" sortable="true" headerClass="sortable"/>    
    <display:column property="description" title="Description" sortable="true" headerClass="sortable"/>    
    <display:column property="createdBy" title="Creator" sortable="true" headerClass="sortable"/>    
    <display:column property="creationTS" title="Registration Date" sortable="true" headerClass="sortable"/>
</display:table>
    
</c:if>