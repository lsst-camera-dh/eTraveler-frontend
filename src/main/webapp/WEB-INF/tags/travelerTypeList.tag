<%-- 
    Document   : travelerTypeList
    Created on : May 3, 2013, 2:56:44 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="hardwareTypeId"%>

<sql:query var="result" dataSource="jdbc/rd-lsst-cam">
    select P.id, P.name as processName, P.version, HT.name as hardwareName, HT.id as hardwareTypeId, count(A.id) as count 
    from
    Process P
    inner join HardwareType HT on HT.id=P.hardwareTypeId
    left join Activity A on A.processId=P.id
    left join ProcessEdge PE on PE.child=P.id
    where PE.id is null
    <c:if test="${! empty hardwareTypeId}">
        and HT.id=?<sql:param value="${hardwareTypeId}"/>
    </c:if>
    group by P.id
</sql:query>
<display:table name="${result.rows}" class="datatable">
    <display:column property="processName" sortable="true" headerClass="sortable"
                    href="displayProcess.jsp" paramId="processPath" paramProperty="id"/>
    <display:column property="version" sortable="true" headerClass="sortable"/>
    <display:column property="hardwareName" title="Component Type" sortable="true" headerClass="sortable"
                    href="displayHardwareType.jsp" paramId="hardwareTypeId" paramProperty="hardwareTypeId"/>
    <display:column property="count" sortable="true" headerClass="sortable"/>
</display:table>
