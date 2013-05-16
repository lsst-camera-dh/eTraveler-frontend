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

<sql:query var="result" dataSource="jdbc/rd-lsst-cam">
    select H.id, H.creationTS, H.lsstId, HT.name as hardwareName, HT.id as hardwareTypeId
    from Hardware H, HardwareType HT
    where HT.id=H.typeId 
    <c:if test="${! empty hardwareTypeId}">
        and HT.id=?<sql:param value="${hardwareTypeId}"/>
    </c:if>
</sql:query>
<display:table name="${result.rows}" class="datatable">
    <display:column property="lsstId" title="Component Id" sortable="true" headerClass="sortable"
                    href="displayHardware.jsp" paramId="hardwareId" paramProperty="id"/>
    <display:column property="hardwareName" title="Type" sortable="true" headerClass="sortable"
                    href="displayHardwareType.jsp" paramId="hardwareTypeId" paramProperty="hardwareTypeId"/>
    <display:column property="creationTS" title="Registration Date" sortable="true" headerClass="sortable"/>
</display:table>
