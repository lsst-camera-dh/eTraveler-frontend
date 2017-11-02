<%-- 
    Document   : labelList
    Created on : November 11, 2016, 3:25 PM
    Author     : jrb
--%>

<%@tag description="List Labels" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="labelGroupId"%>
<%@attribute name="labelGroupName"%>
<%@attribute name="name"%>
<%@attribute name="subsystemId"%>
<%@attribute name="subsystemName"%>
<%@attribute name="labelableId"%>
<%@attribute name="labelableObject"%>
<%@attribute name="hardwareGroupName"%>

<c:set var="lgNameKnown" value="${! empty labelGroupName && labelGroupName != 'any'}"/>
<c:set var="lgKnown" value="${! empty labelGroupId || lgNameKnown}"/>
<c:set var="loNameKnown" value="${! empty labelableObject && labelableObject != 'any'}"/>
<c:set var="loKnown" value="${! empty labelableId || loNameKnown || lgKnown}"/>
<c:set var="ssNameKnown" value="${! empty subsystemName && subsystemName != 'any'}"/>
<c:set var="ssKnown" value="${! empty subsystemId || ssNameKnown || lgKnown}"/>
<c:set var="hgNameKnown" value="${! empty hardwareGroupName && hardwareGroupName != 'any'}"/>
<c:set var="hgKnown" value="${hgNameKnown || lgKnown}"/>

<%--  L.name, LG.name as groupName, --%>
<sql:query var="result" >
  select L.id, SS.name as subsystem, SS.id as subsystemId, L.creationTS as labelTS, L.createdBy as labelCreator,
  LG.name as groupName, LG.id as labelGroupId, L.name as labelName, HG.name as hgName, HG.id as hgId,
  LL.name as objectType ,
(select count(*) 
from LabelHistory LH
where id in (select max(id) from LabelHistory LH2 where LH2.labelId = L.id group by objectId)
and LH.adding = 1) as count  
  from LabelGroup LG
  inner join Labelable LL on LL.id = LG.labelableId 
  left join Label L on L.labelGroupId=LG.id 
  left join Subsystem as SS on LG.subsystemId=SS.id
  left join HardwareGroup as HG on LG.hardwareGroupId = HG.id

  where 1
  <c:if test="${! empty labelGroupId}">
     and LG.id=?<sql:param value="${labelGroupId}"/>
  </c:if>
  <%--
  <c:if test="${! empty labelableId}">
     and LL.id=?<sql:param value="{labelableId}"/>
  </c:if>
  <c:if test="${! empty subsystemId}">
     and S.id=?<sql:param value="{subsystemId}"/>
  </c:if>
  --%>


  <c:if test="${lgNameKnown}">
    and LG.name=?<sql:param value="${labelGroupName}"/>
  </c:if>

    <c:if test="${loNameKnown}">
    and LL.name=?<sql:param value="${labelableObject}"/>
    </c:if>

    <c:if test="${hgNameKnown}">
    and HG.name=?<sql:param value="${hardwareGroupName}"/>
    </c:if>

    <c:if test="${! empty name}">
      and L.name like concat('%', ?<sql:param value="${name}"/>, '%')
    </c:if>


    <c:if test="${ssNameKnown}">
    and SS.name=?<sql:param value="${subsystemName}"/>
    </c:if>

     order by objectType, groupName, labelName;
</sql:query>

<display:table name="${result.rows}" id="row" class="datatable" sort="list"
               pagesize="${fn:length(result.rows) > preferences.pageLength ? preferences.pageLength : 0}">
    <c:if test="${! loKnown || preferences.showFilteredColumns}">
  <display:column property="objectType" title="Labelable Objects"
                  sortable="true" headerClass="sortable" />
    </c:if>
    <c:if test="${! lgKnown || preferences.showFilteredColumns}">
  <display:column property="groupName" title="Label Group"
                  sortable="true" headerClass="sortable" 
                  href="displayLabelGroup.jsp" paramId="labelGroupId" paramProperty="labelGroupId"/>
    </c:if>    
  <display:column property="labelName" title="Label"
                  sortable="true" headerClass="sortable" 
                  href="displayLabel.jsp" paramId="labelId" paramProperty="id"/>
  <display:column property="count" title="Count"
                  sortable="true" headerClass="sortable" />
  <c:if test="${! ssKnown || preferences.showFilteredColumns}">
  <display:column property="subsystem" title="Subsystem"
                  sortable="true" headerClass="sortable" 
                  href="displaySubsystem.jsp" paramId="subsystemId" paramProperty="subsystemId"/>
  </c:if>
  <c:if test="${! hgKnown || preferences.showFilteredColumns}">
  <display:column property="hgName" title="Hardware Group"
                  sortable="true" headerClass="sortable"  
                  href="displayHardwareGroup.jsp" paramId="hardwareGroupId" paramProperty="hgId"/>
  </c:if>
  <display:column property="labelCreator" title="Creator"
                  sortable="true" headerClass="sortable" />
  <display:column property="labelTS" title="Creation Time"
                  sortable="true" headerClass="sortable" />


  </display:table>

  <%--
     pagesize="${fn:length(result.rows) > preferences.pageLength ? preferences.pageLength : 0}">
  --%>
  <%--
  href="displayHardware.jsp" paramId="hardwareId"
  paramProperty="id"/>
  --%>
