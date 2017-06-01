<%-- 
    Document   : activityList
    Created on : May 3, 2013, 3:49:57 PM
    Author     : focke
--%>

<%@tag description="List Activities" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>

<%@attribute name="done"%>
<%@attribute name="hardwareId"%>
<%@attribute name="processId"%>
<%@attribute name="travelersOnly"%>
<%@attribute name="userId"%>
<%@attribute name="version"%> 
<%@attribute name="name"%>
<%@attribute name="camSerial"%>
<%@attribute name="manSerial"%>
<%@attribute name="type"%>
<%@attribute name="status"%>
<%@attribute name="perHw"%>
<%@attribute name="subsystemId"%>
<%@attribute name="subsystemName"%>

<c:if test="${empty perHw}"><c:set var="perHw" value="false"/></c:if>

    <sql:query var="result" >
select A.id as activityId, A.begin, A.end, A.createdBy, A.closedBy, A.creationTS,
    AFS.name as status,
    P.id as processId, 
    concat(P.name, ' v', P.version) as processName,
    P.shortDescription,
    H.id as hardwareId, H.lsstId, H.manufacturerId,
    HT.name as hardwareName, HT.id as hardwareTypeId,
    SS.id as subsystemId, SS.name as subsystemName,
    HI.identifier as nickName
from Activity A
    inner join Process P on A.processId=P.id
    inner join Hardware H on A.hardwareId=H.id
    inner join HardwareType HT on H.hardwareTypeId=HT.id
    inner join Subsystem SS on SS.id=HT.subsystemId
    inner join ActivityStatusHistory ASH on ASH.activityId=A.id and ASH.id=(select max(id) from ActivityStatusHistory where activityId=A.id)
    inner join ActivityFinalStatus AFS on AFS.id=ASH.activityStatusId
    left join HardwareIdentifier HI on HI.hardwareId=H.id 
        and HI.authorityId=(select id from HardwareIdentifierAuthority where name=?<sql:param value="${preferences.idAuthName}"/>)
where true
    <c:if test="${! empty travelersOnly}">
        and A.processEdgeId IS NULL 
    </c:if>
    <c:if test="${! empty processId}">
        and P.id=?<sql:param value="${processId}"/>
    </c:if>
    <c:if test="${! empty name}">
        and P.name like concat('%', ?<sql:param value="${name}"/>, '%')
    </c:if>
    <c:if test="${! empty camSerial}">
        and H.lsstId like concat('%', ?<sql:param value="${camSerial}"/>, '%')
    </c:if>
    <c:if test="${! empty manSerial}">
        and H.manufacturerId like concat('%', ?<sql:param value="${manSerial}"/>, '%')
    </c:if>
    <c:if test="${! empty type}">
        and HT.name like concat('%', ?<sql:param value="${type}"/>, '%')
    </c:if>
    <c:if test="${! empty hardwareId}">
        and H.id=?<sql:param value="${hardwareId}"/>
    </c:if>
    <c:if test="${! empty done}">
        and <c:if test="${! done}">not</c:if> AFS.isFinal
    </c:if>
    <c:if test="${! empty status && status != 'any'}">
        and AFS.name=?<sql:param value="${status}"/>
    </c:if>
    <c:if test="${! empty userId}">
        and (A.createdBy=?<sql:param value="${userId}"/> or A.closedBy=?<sql:param value="${userId}"/>)
    </c:if>
    <c:if test="${version=='latest'}">
        and P.version=(select max(version) from Process where name=P.name)
    </c:if>
    <c:if test="${perHw}">
        and A.id=(select max(id) from Activity where hardwareId=H.id)
        group by H.id
    </c:if>
    <c:if test="${! empty subsystemId && subsystemName != 'Any'}">
        and SS.id=?<sql:param value="${subsystemId}"/>
    </c:if>
    <c:if test="${! empty subsystemName && subsystemName != 'Any'}">
        and SS.name=?<sql:param value="${subsystemName}"/>
    </c:if>
order by A.id desc
;
    </sql:query>
<c:if test="${! empty result.rows}">
    <display:table name="${result.rows}" class="datatable" sort="list"
                   pagesize="${fn:length(result.rows) > preferences.pageLength ? preferences.pageLength : 0}">
    <%--    <display:column property="processName" title="Name" sortable="true" headerClass="sortable"
                          href="displayActivity.jsp" paramId="activityId" paramProperty="activityId"/>--%>
        <display:column property="shortDescription" title="Description" sortable="true" headerClass="sortable"
            href="displayActivity.jsp" paramId="activityId" paramProperty="activityId"/>
        <c:if test="${empty hardwareId or preferences.showFilteredColumns}">
            <display:column property="lsstId" title="${appVariables.experiment} Serial Number" sortable="true" headerClass="sortable"
                            href="displayHardware.jsp" paramId="hardwareId" paramProperty="hardwareId"/>
            <display:column property="manufacturerId" title="Manufacturer Serial Number" sortable="true" headerClass="sortable"
                            href="displayHardware.jsp" paramId="hardwareId" paramProperty="hardwareId"/>
            <c:if test="${'null' != preferences.idAuthName}">
                <display:column property="nickName" title="${preferences.idAuthName} Identifier" sortable="true" headerClass="sortable"/>
            </c:if>
        </c:if>
        <c:if test="${(empty processId && empty hardwareId) || preferences.showFilteredColumns}">
            <display:column property="hardwareName" title="Component Type" sortable="true" headerClass="sortable"
                            href="displayHardwareType.jsp" paramId="hardwareTypeId" paramProperty="hardwareTypeId"/>
        </c:if>
        <c:if test="${(empty subsystemId and (empty subsystemName or subsystemName == 'Any') and empty hardwareId and empty processId) or preferences.showFilteredColumns}">
            <display:column property="subsystemName" title="Subsystem" sortable="true" headerClass="sortable"
                            href="displaySubsystem.jsp" paramId="subsystemId" paramProperty="subsystemId"/>
        </c:if>
        <display:column property="creationTS" title="creation" sortable="true" headerClass="sortable"/>
        <display:column property="createdBy" sortable="true" headerClass="sortable"/>
        <display:column property="begin" sortable="true" headerClass="sortable"/>
        <c:if test="${(empty status || status == 'any') || preferences.showFilteredColumns}">
            <display:column property="status" sortable="true" headerClass="sortable"/>
        </c:if>
        <display:column property="end" sortable="true" headerClass="sortable"/>
        <display:column property="closedBy" sortable="true" headerClass="sortable"/>
    </display:table>        
</c:if>
