<%-- 
    Document   : hardwareList
    Created on : May 3, 2013, 3:05:28 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="hardwareTypeId"%>
<%@attribute name="hardwareStatusId"%>

<sql:query var="result" dataSource="jdbc/rd-lsst-cam">
    select H.id, H.creationTS, H.lsstId, H.manufacturer, H.model, H.manufactureDate,
    HT.name as hardwareName, HT.id as hardwareTypeId, 
    HS.name as hardwareStatusName
    from Hardware H, HardwareType HT, HardwareStatus HS
    where HT.id=H.hardwareTypeId 
    and HS.id=H.hardwareStatusId
    <c:if test="${! empty hardwareTypeId}">
        and HT.id=?<sql:param value="${hardwareTypeId}"/>
    </c:if>
    <c:if test="${! empty hardwareStatusId}">
        and HS.id=?<sql:param value="${hardwareStatusId}"/>
    </c:if>
</sql:query>
<display:table name="${result.rows}" class="datatable">
    <display:column property="lsstId" title="Component Id" sortable="true" headerClass="sortable"
                    href="displayHardware.jsp" paramId="hardwareId" paramProperty="id"/>
    <c:if test="${empty hardwareTypeId}">
        <display:column property="hardwareName" title="Type" sortable="true" headerClass="sortable"
                        href="displayHardwareType.jsp" paramId="hardwareTypeId" paramProperty="hardwareTypeId"/>
    </c:if>
    <c:if test="${empty hardwareStatusId}">
        <display:column property="hardwareStatusName" title="Status" sortable="true" headerClass="sortable"/>
    </c:if>
    <display:column property="creationTS" title="Registration Date" sortable="true" headerClass="sortable"/>
    <display:column property="manufacturer" sortable="true" headerClass="sortable"/>
    <display:column property="model" sortable="true" headerClass="sortable"/>
    <display:column property="manuFactureDate" title="Manufacture Date" sortable="true" headerClass="sortable"/>
</display:table>
