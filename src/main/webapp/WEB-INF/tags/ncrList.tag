<%-- 
    Document   : ncrList
    Created on : Apr 3, 2017, 2:51:58 PM
    Author     : focke
--%>

<%@tag description="List NCRs" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>

<%@attribute name="exceptionName"%>
<%@attribute name="travelerName"%>
<%@attribute name="parentName"%>
<%@attribute name="componentName"%>
<%@attribute name="componentType"%>

    <sql:query var="ncrQ">
select An.id as ncrId, Pn.name as ncrName, An.creationTS, Ap.createdBy,
if(Ap.id = An.id, null, Ap.id) as parentId, if(Ap.id = An.id, null, Pp.name) as parentName,
H.lsstId, H.id as hardwareId, HT.name as typeName, HT.id as hardwareTypeId,
ET.conditionString as exceptionName
from Exception E
inner join ExceptionType ET on ET.id = E.exceptionTypeId
inner join Activity An on An.id = E.NCRActivityId
inner join Process Pn on Pn.id = An.processId
inner join Activity Ae on Ae.id = E.exitActivityId
inner join Activity Ap on Ap.id = Ae.rootActivityId
inner join Process Pp on Pp.id = Ap.processId
inner join Hardware H on H.id = An.hardwareId
inner join HardwareType HT on HT.id = H.hardwareTypeId
where true
<c:if test="${! empty exceptionName}">
    and ET.conditionString like concat('%' ?<sql:param value="${exceptionName}"/> '%')
</c:if>
<c:if test="${! empty travelerName}">
    and Pn.name like concat('%' ?<sql:param value="${travelerName}"/> '%')
</c:if>
<c:if test="${! empty parentName}">
    and Pp.name like concat('%' ?<sql:param value="${parentName}"/> '%')
</c:if>
<c:if test="${! empty componentName}">
    and H.lsstId like concat('%' ?<sql:param value="${componentName}"/> '%')
</c:if>
<c:if test="${! empty componentType}">
    and HT.name like concat('%' ?<sql:param value="${componentType}"/> '%')
</c:if>
order by An.id desc
;
    </sql:query>

<display:table name="${ncrQ.rows}" class="datatable" sort="list"
               pagesize="${fn:length(result.rows) > preferences.pageLength ? preferences.pageLength : 0}">
    <display:column property="ncrName" title="NCR Traveler" sortable="true" headerClass="sortable"
        href="displayActivity.jsp" paramId="activityId" paramProperty="ncrId"/>
    <display:column property="exceptionName" title="Exception" sortable="true" headerClass="sortable"/>
    <display:column property="parentName" title="Parent Traveler" sortable="true" headerClass="sortable"
        href="displayActivity.jsp" paramId="activityId" paramProperty="parentId"/>
    <display:column property="lsstId" title="${appVariables.experiment} Serial Number" sortable="true" headerClass="sortable"
        href="displayHardware.jsp" paramId="hardwareId" paramProperty="hardwareId"/>
    <display:column property="typeName" title="Component Type" sortable="true" headerClass="sortable"
        href="displayHardwareType.jsp" paramId="hardwareTypeId" paramProperty="hardwareTypeId"/>
    <display:column property="creationTS" title="Creation" sortable="true" headerClass="sortable"/>
    <display:column property="createdBy" sortable="true" headerClass="sortable"/>
</display:table>
