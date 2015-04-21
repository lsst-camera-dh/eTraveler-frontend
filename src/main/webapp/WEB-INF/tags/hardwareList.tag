<%-- 
    Document   : hardwareList
    Created on : May 3, 2013, 3:05:28 PM
    Author     : focke
--%>

<%@tag description="List Hardware" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="hardwareGroupId"%>
<%@attribute name="hardwareTypeId"%>
<%@attribute name="hardwareStatusId"%>
<%@attribute name="siteId"%>
<%@attribute name="locationId"%>

<sql:query var="result" >
    select H.id, H.creationTS, H.lsstId, H.manufacturer, H.manufacturerId, H.model, H.manufactureDate,
    HT.name as hardwareTypeName, HT.id as hardwareTypeId, 
    HS.name as hardwareStatusName,
    L.id as locationId, L.name as locationName,
    S.id as siteId, S.name as siteName,
    HI.identifier as nickName,
    count(A.id) as nTravelers
    from Hardware H
    inner join HardwareType HT on HT.id=H.hardwareTypeId
    <c:if test="${! empty hardwareGroupId}">
        inner join HardwareTypeGroupMapping HTGM on HTGM.hardwareTypeId=HT.id
    </c:if>
    inner join HardwareStatusHistory HSH on HSH.hardwareId=H.id and HSH.id=(select max(id) from HardwareStatusHistory where hardwareId=H.id)
    inner join HardwareStatus HS on HS.id=HSH.hardwareStatusId
    inner join HardwareLocationHistory HLH on HLH.hardwareId=H.id and HLH.id=(select max(id) from HardwareLocationHistory where hardwareId=H.id)
    inner join Location L on L.id=HLH.locationId
    inner join Site S on S.id=L.siteId
    left join HardwareIdentifier HI on HI.hardwareId=H.id 
        and HI.authorityId=(select id from HardwareIdentifierAuthority where name=?<sql:param value="${preferences.idAuthName}"/>)
    left join Activity A on A.hardwareId=H.id
    where A.parentActivityId is null
    <c:if test="${! empty hardwareGroupId}">
        and HTGM.hardwareGroupId=?<sql:param value="${hardwareGroupId}"/>
    </c:if>
    <c:if test="${! empty hardwareTypeId}">
        and HT.id=?<sql:param value="${hardwareTypeId}"/>
    </c:if>
    <c:if test="${! empty hardwareStatusId}">
        and HS.id=?<sql:param value="${hardwareStatusId}"/>
    </c:if>
    <c:if test="${! empty siteId}">
        and siteId=?<sql:param value="${siteId}"/>
    </c:if>
    <c:if test="${! empty locationId}">
        and locationId=?<sql:param value="${locationId}"/>
    </c:if>
    group by H.id
    ;
</sql:query>
<display:table name="${result.rows}" id="row" class="datatable" sort="list"
               pagesize="${fn:length(result.rows) > preferences.pageLength ? preferences.pageLength : 0}">
    <display:column property="lsstId" title="${appVariables.experiment} Serial Number" sortable="true" headerClass="sortable"
                    href="displayHardware.jsp" paramId="hardwareId" paramProperty="id"/>
    <display:column property="manufacturerId" title="Manufacturer Serial Number" sortable="true" headerClass="sortable"
                    href="displayHardware.jsp" paramId="hardwareId" paramProperty="id"/>
    <c:if test="${'null' != preferences.idAuthName}">
        <display:column property="nickName" title="${preferences.idAuthName} Identifier" sortable="true" headerClass="sortable"/>
    </c:if>
    <c:if test="${empty hardwareTypeId or preferences.showFilteredColumns}">
        <display:column property="hardwareTypeName" title="Type" sortable="true" headerClass="sortable"
                        href="displayHardwareType.jsp" paramId="hardwareTypeId" paramProperty="hardwareTypeId"/>
    </c:if>
    <c:if test="${empty hardwareStatusId or preferences.showFilteredColumns}">
        <display:column property="hardwareStatusName" title="Status" sortable="true" headerClass="sortable"/>
    </c:if>
    <display:column property="nTravelers" title="# Travelers" sortable="true" headerClass="sortable"
                    href="listTravelers.jsp" paramId="hardwareId" paramProperty="id"/>
    <display:column title="# Components" sortable="true" headerClass="sortable">
        <traveler:countComponents var="nComps" hardwareId="${row.id}"/>
        <c:out value="${nComps}"/>
    </display:column>
    <c:if test="${(empty siteId and empty locationId) or preferences.showFilteredColumns}">
        <display:column property="siteName" title="Site" sortable="true" headerClass="sortable"
                        href="displaySite.jsp" paramId="siteId" paramProperty="siteId"/>
    </c:if>
    <c:if test="${empty locationId or preferences.showFilteredColumns}">
        <display:column property="locationName" title="Location" sortable="true" headerClass="sortable"
                        href="displayLocation.jsp" paramId="locationId" paramProperty="locationId"/>
    </c:if>
    <display:column property="creationTS" title="Registration Date" sortable="true" headerClass="sortable"/>
    <display:column property="manufacturer" sortable="true" headerClass="sortable"/>
    <display:column property="model" sortable="true" headerClass="sortable"/>
    <display:column property="manuFactureDate" title="Manufacture Date" sortable="true" headerClass="sortable"/>
</display:table>
