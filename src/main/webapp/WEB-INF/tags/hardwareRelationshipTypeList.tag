<%-- 
    Document   : hardwareRelationshipTypeList
    Created on : Jan 7, 2015, 2:12:43 PM
    Author     : focke
--%>

<%@tag description="List HardwareRelationshipTypes" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>

<sql:query var="hrtQ">
    select HRT.*, 
    HTP.name as assemblyType, 
    HTC.name as componentType
    from HardwareRelationshipType HRT
    inner join HardwareType HTP on HTP.id=HRT.hardwareTypeId
    inner join HardwareType HTC on HTC.id=HRT.componentTypeId
    ;
</sql:query>

<display:table name="${hrtQ.rows}" class="datatable">
    <display:column property="name" sortable="true" headerClass="sortable"/>
    <display:column property="assemblyType" sortable="true" headerClass="sortable"
                    href="displayHardwareType.jsp" paramId="hardwareTypeId" paramProperty="hardwareTypeId"/>
    <display:column property="componentType" sortable="true" headerClass="sortable"
                    href="displayHardwareType.jsp" paramId="hardwareTypeId" paramProperty="componentTypeId"/>
    <display:column property="createdBy" title="Creator" sortable="true" headerClass="sortable"/>
    <display:column property="creationTS" title="Date" sortable="true" headerClass="sortable"/>
</display:table>
