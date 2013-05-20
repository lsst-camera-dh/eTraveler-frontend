<%-- 
    Document   : travelerList
    Created on : May 3, 2013, 3:49:57 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="processId"%>
<%@attribute name="hardwareId"%>
<%@attribute name="end"%>

<sql:query var="result" dataSource="jdbc/rd-lsst-cam">
  select A.id as activityId, A.begin, A.end, A.createdBy, A.closedBy,
    concat(P.name, ' v', P.version) as processName,
    H.id as hardwareId, H.lsstId, 
    HT.name as hardwareName, HT.id as hardwareTypeId
    from Activity A, Process P, Hardware H, HardwareType HT 
    where 
    A.processEdgeId IS NULL 
    AND 
    A.processId=P.id 
    AND A.hardwareId=H.id 
    AND H.typeId=HT.id
    <c:if test="${! empty processId}">
        and P.id=?<sql:param value="${processId}"/>
    </c:if>
    <c:if test="${! empty hardwareId}">
        and H.id=?<sql:param value="${hardwareId}"/>
    </c:if>
    <c:if test="${! empty end}">
        and A.end is <c:if test="${end!='None'}">not</c:if> null
    </c:if>
</sql:query>
<display:table name="${result.rows}" class="datatable">
    <display:column property="processName" title="Traveler" sortable="true" headerClass="sortable"
                    href="displayActivity.jsp" paramId="activityId" paramProperty="activityId"/>
    <display:column property="lsstId" title="Component" sortable="true" headerClass="sortable"
                    href="displayHardware.jsp" paramId="hardwareId" paramProperty="hardwareId"/>
    <display:column property="hardwareName" title="Component Type" sortable="true" headerClass="sortable"
                    href="displayHardwareType.jsp" paramId="hardwareTypeId" paramProperty="hardwareTypeId"/>
    <display:column property="begin" sortable="true" headerClass="sortable"/>
    <display:column property="createdBy" sortable="true" headerClass="sortable"/>
    <display:column property="end" sortable="true" headerClass="sortable"/>
    <display:column property="closedBy" sortable="true" headerClass="sortable"/>
</display:table>        
