<%-- 
    Document   : hardwareGroupList
    Created on : Mar 12, 2015, 4:23:53 PM
    Author     : focke
--%>

<%@tag description="List hardware groups" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>

<%@attribute name="name"%>
<%@attribute name="hardwareTypeId"%>

<sql:query var="groupsQ">
    select HG.id as hardwareGroupId, HG.name as hardwareGroupName, HG.description, count(HTGM.id) as nTypes
    from HardwareGroup HG
    left join HardwareTypeGroupMapping HTGM on HTGM.hardwareGroupId=HG.id
    <c:if test="${! empty hardwareTypeId}">
        inner join HardwareTypeGroupMapping HTGMS on HTGMS.hardwareGroupId=HG.id
    </c:if>
    where true
    <c:if test="${! empty hardwareTypeId}">
        and HTGMS.hardwareTypeId=?<sql:param value="${hardwareTypeId}"/>
    </c:if>
    <c:if test="${! empty name}">
        and (HG.name like concat('%', ?<sql:param value="${name}"/>, '%')
        or HG.description like concat('%', ?<sql:param value="${name}"/>, '%'))
    </c:if>
    group by HG.id
    order by name
    ;
</sql:query>

<display:table name="${groupsQ.rows}" class="datatable" sort="list"
               pagesize="${fn:length(groupsQ.rows) > preferences.pageLength ? preferences.pageLength : 0}">
    <display:column property="hardwareGroupName" title="Name" sortable="true" headerClass="sortable"
                    href="displayHardwareGroup.jsp" paramId="hardwareGroupId" paramProperty="hardwareGroupId"/>
    <display:column property="description" sortable="true" headerClass="sortable"/>
    <display:column property="nTypes" title="Member Types" sortable="true" headerClass="sortable"/>    
</display:table>
