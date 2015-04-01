<%-- 
    Document   : travelerList
    Created on : May 3, 2013, 3:49:57 PM
    Author     : focke
--%>

<%@tag description="List Activities" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>

<%@attribute name="done"%>
<%@attribute name="hardwareId"%>
<%@attribute name="processId"%>
<%@attribute name="travelersOnly"%>
<%@attribute name="userId"%>

<sql:query var="result" >
  select A.id as activityId, A.begin, A.end, A.createdBy, A.closedBy,
    AFS.name as status,
    P.id as processId, concat(P.name, ' v', P.version) as processName,
    H.id as hardwareId, H.lsstId, H.manufacturerId,
    HT.name as hardwareName, HT.id as hardwareTypeId
    from Activity A
    inner join Process P on A.processId=P.id
    inner join Hardware H on A.hardwareId=H.id
    inner join HardwareType HT on H.hardwareTypeId=HT.id
    left join ActivityFinalStatus AFS on AFS.id=A.activityFinalStatusId
    where 1
    <c:if test="${! empty travelersOnly}">
        and A.processEdgeId IS NULL 
    </c:if>
    <c:if test="${! empty processId}">
        and P.id=?<sql:param value="${processId}"/>
    </c:if>
    <c:if test="${! empty hardwareId}">
        and H.id=?<sql:param value="${hardwareId}"/>
    </c:if>
    <c:if test="${! empty done}">
        and A.end is <c:if test="${done}">not</c:if> null
    </c:if>
    <c:if test="${! empty userId}">
        and (A.createdBy=?<sql:param value="${userId}"/> or A.closedBy=?<sql:param value="${userId}"/>
    </c:if>
    order by A.id desc;
</sql:query>
<display:table name="${result.rows}" class="datatable">
    <display:column property="processName" title="Name" sortable="true" headerClass="sortable"
                      href="displayActivity.jsp" paramId="activityId" paramProperty="activityId"/>
    <c:if test="${empty hardwareId}">
        <display:column property="lsstId" title="LSST Serial Number" sortable="true" headerClass="sortable"
                        href="displayHardware.jsp" paramId="hardwareId" paramProperty="hardwareId"/>
        <display:column property="manufacturerId" title="Manufacturer Serial Number" sortable="true" headerClass="sortable"
                        href="displayHardware.jsp" paramId="hardwareId" paramProperty="hardwareId"/>
    </c:if>
    <c:if test="${(empty processId) and (empty hardwareId)}">
        <display:column property="hardwareName" title="Component Type" sortable="true" headerClass="sortable"
                        href="displayHardwareType.jsp" paramId="hardwareTypeId" paramProperty="hardwareTypeId"/>
    </c:if>
    <display:column property="begin" sortable="true" headerClass="sortable"/>
    <display:column property="createdBy" sortable="true" headerClass="sortable"/>
    <display:column property="status" sortable="true" headerClass="sortable"/>
        <display:column property="end" sortable="true" headerClass="sortable"/>
        <display:column property="closedBy" sortable="true" headerClass="sortable"/>
</display:table>        
