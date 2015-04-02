<%-- 
    Document   : hardwareTypeList
    Created on : May 3, 2013, 4:12:35 PM
    Author     : focke
--%>

<%@tag description="List HardwareTypes" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>

<%@attribute name="hardwareGroupId"%>

<sql:query var="result" >
    select HT.id, HT.name, HT.description, count(H.id) as count
    from
    HardwareType HT
    <c:if test="${! empty hardwareGroupId}">
        inner join HardwareTypeGroupMapping HTGM on HTGM.hardwareTypeId=HT.id
    </c:if>
    left join Hardware H on H.hardwareTypeId=HT.id
    <c:if test="${! empty hardwareGroupId}">
        where HTGM.hardwareGroupId=?<sql:param value="${hardwareGroupId}"/>
    </c:if>
    group by HT.id;
</sql:query>
<display:table name="${result.rows}" class="datatable" pagesize="${preferences.pageLength}" sort="list">
    <display:column property="name" title="Name" sortable="true" headerClass="sortable"
                    href="displayHardwareType.jsp" paramId="hardwareTypeId" paramProperty="id"/>
    <display:column property="description" sortable="true" headerClass="sortable"/>
    <display:column property="count" sortable="true" headerClass="sortable"/>
</display:table>
