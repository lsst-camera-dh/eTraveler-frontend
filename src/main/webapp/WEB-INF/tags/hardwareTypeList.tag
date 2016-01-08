<%-- 
    Document   : hardwareTypeList
    Created on : May 3, 2013, 4:12:35 PM
    Author     : focke
--%>

<%@tag description="List HardwareTypes" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>

<%@attribute name="hardwareGroupId"%>
<%@attribute name="name"%>
<%@attribute name="subsystemId"%>
<%@attribute name="subsystemName"%>

<sql:query var="result" >
    select HT.id, HT.name, HT.description, count(H.id) as count,
    SS.id as subsystemId, SS.name as subsystemName
    from
    HardwareType HT
    inner join Subsystem SS on SS.id=HT.subsystemId
    <c:if test="${! empty hardwareGroupId}">
        inner join HardwareTypeGroupMapping HTGM on HTGM.hardwareTypeId=HT.id
    </c:if>
    left join Hardware H on H.hardwareTypeId=HT.id
    where true
    <c:if test="${! empty hardwareGroupId}">
        and HTGM.hardwareGroupId=?<sql:param value="${hardwareGroupId}"/>
    </c:if>
    <c:if test="${! empty name}">
        and HT.name like concat('%', ?<sql:param value="${name}"/>, '%')
    </c:if>
    <c:if test="${! empty subsystemId && subsystemName != 'Any'}">
        and SS.id=?<sql:param value="${subsystemId}"/>
    </c:if>
    <c:if test="${! empty subsystemName && subsystemName != 'Any'}">
        and SS.name=?<sql:param value="${subsystemName}"/>
    </c:if>
    group by HT.id;
</sql:query>
<display:table name="${result.rows}" class="datatable" sort="list"
               pagesize="${fn:length(result.rows) > preferences.pageLength ? preferences.pageLength : 0}">
    <display:column property="name" title="Name" sortable="true" headerClass="sortable"
                    href="displayHardwareType.jsp" paramId="hardwareTypeId" paramProperty="id"/>
    <display:column property="description" sortable="true" headerClass="sortable"/>
    <display:column property="count" sortable="true" headerClass="sortable"/>
    <c:if test="${(empty subsystemId and (empty subsystemName or subsystemName == 'Any')) or preferences.showFilteredColumns}">
        <display:column property="subsystemName" title="Subsystem" sortable="true" headerClass="sortable"
                        href="displaySubsystem.jsp" paramId="subsystemId" paramProperty="subsystemId"/>
    </c:if>
</display:table>
