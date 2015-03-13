<%-- 
    Document   : hardwareGroupList
    Created on : Mar 12, 2015, 4:23:53 PM
    Author     : focke
--%>

<%@tag description="List hardware groups" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>

<%@attribute name="hardwareTypeId"%>

<sql:query var="groupsQ">
    select HG.id as hardwareGroupId, HG.name as hardwareGroupName, HG.description, count(HTGM.id) as nTypes
    from HardwareGroup HG
    inner join HardwareTypeGroupMapping HTGM on HTGM.hardwareGroupId=HG.id
    <c:if test="${!empty hardwareTypeId}">
        where HTGM.hardwareTypeId=?<sql:param value="${hardwareTypeId}"/>
    </c:if>
    group by HG.id
</sql:query>

<display:table name="${groupsQ.rows}" class="datatable">
    <display:column property="hardwareGroupName" title="Name" sortable="true" headerClass="sortable"
                    href="displayHardwareGroup.jsp" paramId="hardwareGroupId" paramProperty="hardwareGroupId"/>
    <display:column property="description" sortable="true" headerClass="sortable"/>
    <display:column property="nTypes" title="Member Types" sortable="true" headerClass="sortable"/>    
</display:table>
