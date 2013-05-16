<%-- 
    Document   : hardwareTypeList
    Created on : May 3, 2013, 4:12:35 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="hardwareTypeId"%>

<sql:query var="result" dataSource="jdbc/rd-lsst-cam">
    select HT.id, HT.name, count(H.id) as count
    from
    HardwareType HT
    left join Hardware H on H.typeId=HT.id
    where 1
    <c:if test="${! empty hardwareTypeId}">
        and HT.id=?<sql:param value="${hardwareTypeId}"/>
    </c:if>
    group by HT.id
</sql:query>
<display:table name="${result.rows}" class="datatable">
    <display:column property="name" title="Type" sortable="true" headerClass="sortable"
                    href="displayHardwareType.jsp" paramId="hardwareTypeId" paramProperty="id"/>
    <display:column property="count" sortable="true" headerClass="sortable"/>
</display:table>
