<%-- 
    Document   : travelerTypeList
    Created on : May 3, 2013, 2:56:44 PM
    Author     : focke
--%>

<%@tag description="List traveler types" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>

<%@attribute name="hardwareTypeId"%>
<%@attribute name="hardwareGroupId"%>
<%@attribute name="state"%>

<c:set var="activeTravelerTypesOnly" value="false"/> <%-- should get this from user pref --%>

<c:if test="${empty state && activeTravelerTypesOnly}">
    <c:set var="state" value="ACTIVE"/>
</c:if>

<c:url var="inProgressLink" value="listTravelers.jsp">
    <c:param name="end" value="None"/>
</c:url>
<c:url var="completeLink" value="listTravelers.jsp">
    <c:param name="end" value="Any"/>
</c:url>

<sql:query var="result" >
    select P.id as processId, concat(P.name, ' v', P.version) as processName, 
        HG.name as hardwareGroupName, HG.id as hardwareGroupId, 
        TT.state,
        count(A.id)-count(A.end) as inProgress, count(A.id) as total, count(A.end) as completed 
    from
    Process P
    inner join HardwareGroup HG on HG.id=P.hardwareGroupId
    <c:if test="${! empty hardwareTypeId}">
        inner join HardwareTypeGroupMapping HTGM on HTGM.hardwareGroupId=P.hardwareGroupId
    </c:if>
    inner join TravelerType TT on TT.rootProcessId=P.id
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
    <c:if test="${! empty state}">
        and TT.state=?<sql:param value="${state}"/>
    </c:if>
    group by P.id
</sql:query>
<display:table name="${result.rows}" class="datatable" pagesize="${preferences.pageLength}" sort="list">
    <display:column property="processName" title="Name" sortable="true" headerClass="sortable"
                    href="displayProcess.jsp" paramId="processPath" paramProperty="processId"/>
    <c:if test="${empty hardwareGroupId or preferences.showFilteredColumns}">
        <display:column property="hardwareGroupName" title="Component Group" sortable="true" headerClass="sortable"
                        href="displayHardwareGroup.jsp" paramId="hardwareGroupId" paramProperty="hardwareGroupId"/>
    </c:if>
    <c:if test="${empty state or preferences.showFilteredColumns}">
        <display:column property="state" sortable="true" headerClass="sortable"/>
    </c:if>
    <display:column property="inProgress" sortable="true" headerClass="sortable"
                    href="${inProgressLink}" paramId="processId" paramProperty="processId"/>
    <display:column property="completed" sortable="true" headerClass="sortable"
                    href="${completeLink}" paramId="processId" paramProperty="processId"/>
    <display:column property="total" sortable="true" headerClass="sortable"
                    href="listTravelers.jsp" paramId="processId" paramProperty="processId"/>
</display:table>
