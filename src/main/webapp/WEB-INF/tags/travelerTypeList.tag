<%-- 
    Document   : travelerTypeList
    Created on : May 3, 2013, 2:56:44 PM
    Author     : focke
--%>

<%@tag description="List traveler types" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="hardwareTypeId"%>
<%@attribute name="hardwareGroupId"%>
<%@attribute name="state"%>
<%@attribute name="version"%>
<%@attribute name="name"%>
<%@attribute name="subsystemId"%>
<%@attribute name="subsystemName"%>

<c:set var="activeTravelerTypesOnly" value="false"/> <%-- should get this from user pref --%>

<c:if test="${empty state && activeTravelerTypesOnly}">
    <c:set var="state" value="active"/>
</c:if>

<c:url var="inProgressLink" value="listTravelers.jsp">
    <c:param name="done" value="false"/>
</c:url>
<c:url var="completeLink" value="listTravelers.jsp">
    <c:param name="done" value="true"/>
</c:url>

<sql:query var="result" >
    select P.id as processId, concat(P.name, ' v', P.version) as processName, 
        P.shortDescription,
        HG.name as hardwareGroupName, HG.id as hardwareGroupId, 
        TT.id as travelerTypeId, TT.standaloneNCR, TT.creationTS,
        TTS.name as state,
        count(A.id)-count(A.end) as inProgress, count(A.id) as total, count(A.end) as completed,
        max(A.creationTS) as lastUsed,
        SS.id as subsystemId, SS.name as subsystemName
    from
    Process P
    inner join HardwareGroup HG on HG.id=P.hardwareGroupId
    <c:if test="${! empty hardwareTypeId}">
        inner join HardwareTypeGroupMapping HTGM on HTGM.hardwareGroupId=P.hardwareGroupId
    </c:if>
    inner join TravelerType TT on TT.rootProcessId=P.id
    inner join TravelerTypeStateHistory TTSH on 
        TTSH.travelerTypeId=TT.id 
        and TTSH.id=(select max(id) from TravelerTypeStateHistory where travelerTypeId=TT.id)
    inner join TravelerTypeState TTS on TTS.id=TTSH.travelerTypeStateId
    inner join Subsystem SS on SS.id=TT.subsystemId
    left join Activity A on (A.processId=P.id and A.parentActivityId is null)
    where
    <c:choose>
        <c:when test="${! empty hardwareTypeId}">
            HTGM.hardwareTypeId=?<sql:param value="${hardwareTypeId}"/>
        </c:when>
        <c:when test="${! empty hardwareGroupId}">
            P.hardwareGroupId=?<sql:param value="${hardwareGroupId}"/>
        </c:when>
        <c:otherwise>
            true
        </c:otherwise>
    </c:choose>
    <c:if test="${! empty name}">
        and P.name like concat('%', ?<sql:param value="${name}"/>, '%')
    </c:if>
    <c:if test="${! empty subsystemId && subsystemName != 'Any'}">
        and SS.id=?<sql:param value="${subsystemId}"/>
    </c:if>
    <c:if test="${! empty subsystemName && subsystemName != 'Any'}">
        and SS.name=?<sql:param value="${subsystemName}"/>
    </c:if>
    <c:if test="${! empty state && state != 'any'}">
        and TTS.name=?<sql:param value="${state}"/>
    </c:if>
    <c:if test="${version=='latest'}">
        and P.version=(select max(version) from Process where name=P.name and hardwareGroupId=P.hardwareGroupId)
    </c:if>
    group by P.id
    order by TT.standaloneNCR, P.name
    ;
</sql:query>
<display:table name="${result.rows}" id="ttRow" class="datatable" sort="list"
               pagesize="${fn:length(result.rows) > preferences.pageLength ? preferences.pageLength : 0}">
    <display:column property="processName" title="Name" sortable="true" headerClass="sortable"
                    href="displayProcess.jsp" paramId="processPath" paramProperty="processId"/>
    <display:column property="shortDescription" title="Description" sortable="true" headerClass="sortable"
                    href="displayProcess.jsp" paramId="processPath" paramProperty="processId"/>
    <c:if test="${empty hardwareGroupId or preferences.showFilteredColumns}">
        <display:column property="hardwareGroupName" title="Component Group" sortable="true" headerClass="sortable"
                        href="displayHardwareGroup.jsp" paramId="hardwareGroupId" paramProperty="hardwareGroupId"/>
    </c:if>
    <c:if test="${(empty subsystemId and (empty subsystemName or subsystemName == 'Any') and empty hardwareTypeId) or preferences.showFilteredColumns}">
        <display:column property="subsystemName" title="Subsystem" sortable="true" headerClass="sortable"
                        href="displaySubsystem.jsp" paramId="subsystemId" paramProperty="subsystemId"/>
    </c:if>
    <c:if test="${(empty state || state == 'any') || preferences.showFilteredColumns}">
        <display:column property="state" sortable="true" headerClass="sortable"
                        href="displayTravelerType.jsp" paramId="travelerTypeId" paramProperty="travelerTypeId"/>
    </c:if>
    <display:column property="creationTS" title="Created" sortable="true" headerClass="sortable"/>
    <display:column property="lastUsed" title="Last Used" sortable="true" headerClass="sortable"/>
    <display:column title="Steps" sortable="true" headerClass="sortable">
        <traveler:countSteps var="nSteps" processId="${ttRow.processId}"/>
        <c:out value="${nSteps}"/>
    </display:column>
    <display:column property="inProgress" sortable="true" headerClass="sortable"
                    href="${inProgressLink}" paramId="processId" paramProperty="processId"/>
    <display:column property="completed" sortable="true" headerClass="sortable"
                    href="${completeLink}" paramId="processId" paramProperty="processId"/>
    <display:column property="total" sortable="true" headerClass="sortable"
                    href="listTravelers.jsp" paramId="processId" paramProperty="processId"/>
</display:table>
