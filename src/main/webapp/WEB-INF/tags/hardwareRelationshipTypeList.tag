<%-- 
    Document   : hardwareRelationshipTypeList
    Created on : Jan 7, 2015, 2:12:43 PM
    Author     : focke
--%>

<%@tag description="List HardwareRelationshipTypes" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>

<%@attribute name="assemblyTypeId"%>
<%@attribute name="componentTypeId"%>

<sql:query var="hrtQ">
    select HRT.*, 
    HTP.name as assemblyType, 
    HTC.name as componentType
    from HardwareRelationshipType HRT
    inner join HardwareType HTP on HTP.id=HRT.hardwareTypeId
    inner join HardwareType HTC on HTC.id=HRT.componentTypeId
    where true
    <c:if test="${! empty assemblyTypeId}">
        and HRT.hardwareTypeId=?<sql:param value="${assemblyTypeId}"/>
    </c:if>
    <c:if test="${! empty componentTypeId}">
        and HRT.componentTypeId=?<sql:param value="${componentTypeId}"/>
    </c:if>
    ;
</sql:query>

<display:table name="${hrtQ.rows}" class="datatable" sort="list"
               pagesize="${fn:length(hrtQ.rows) > preferences.pageLength ? preferences.pageLength : 0}">
    <display:column property="name" sortable="true" headerClass="sortable"/>
    <c:if test="${empty assemblyTypeId or preferences.showFilteredColumns}">
        <display:column property="assemblyType" sortable="true" headerClass="sortable"
                        href="displayHardwareType.jsp" paramId="hardwareTypeId" paramProperty="hardwareTypeId"/>
    </c:if>
    <c:if test="${empty componentTypeId or preferences.showFilteredColumns}">
        <display:column property="componentType" sortable="true" headerClass="sortable"
                        href="displayHardwareType.jsp" paramId="hardwareTypeId" paramProperty="componentTypeId"/>
    </c:if>
    <display:column property="slot" sortable="true" headerClass="sortable"/>
    <display:column property="description" sortable="true" headerClass="sortable"/>
    <display:column property="createdBy" title="Creator" sortable="true" headerClass="sortable"/>
    <display:column property="creationTS" title="Date" sortable="true" headerClass="sortable"/>
</display:table>
