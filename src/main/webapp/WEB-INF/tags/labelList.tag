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

<%--  L.name, LG.name as groupName, --%>
<sql:query var="result" >
  select L.id, SS.name as subsystem, SS.id as subsystemId, L.creationTS as labelTS, L.createdBy as labelCreator,
  LG.name as groupName, LG.id as labelGroupId, L.name as labelName, HG.name as hgName, HG.id as hgId,
  LL.name as objectType 
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


  <c:if test="${! empty labelGroupName && labelGroupName != 'any'}">
    and LG.name=?<sql:param value="${labelGroupName}"/>
  </c:if>

    <c:if test="${! empty labelableObject && labelableObject != 'any'}">
    and LL.name=?<sql:param value="${labelableObject}"/>
    </c:if>

    <c:if test="${! empty hardwareGroupName && hardwareGroupName != 'any'}">
    and HG.name=?<sql:param value="${hardwareGroupName}"/>
    </c:if>

    <c:if test="${! empty name}">
      and L.name like concat('%', ?<sql:param value="${name}"/>, '%')
    </c:if>


    <c:if test="${! empty subsystemName && subsystemName != 'any'}">
    and SS.name=?<sql:param value="${subsystemName}"/>
    </c:if>

     order by objectType, groupName, labelName;
</sql:query>

<display:table name="${result.rows}" id="row" class="datatable" >
  <display:column property="objectType" title="Labelable object"
                  sortable="true" headerClass="sortable" />
  
  <display:column property="groupName" title="Label Group"
                  sortable="true" headerClass="sortable" 
                  href="displayLabelGroup.jsp" paramId="labelGroupId" paramProperty="labelGroupId"/>
  <display:column property="labelName" title="Label"
                  sortable="true" headerClass="sortable" 
                  href="displayLabel.jsp" paramId="labelId" paramProperty="id"/>
  <display:column property="subsystem" title="Subsystem"
                  sortable="true" headerClass="sortable" 
                  href="displaySubsystem.jsp" paramId="subsystemId" paramProperty="subsystemId"/>
  <display:column property="hgName" title="Hardware group"
                  sortable="true" headerClass="sortable"  
                  href="displayHardwareGroup.jsp" paramId="hardwareGroupId" paramProperty="hgId"/>
  <display:column property="labelCreator" title="Creator"
                  sortable="true" headerClass="sortable" />

  <display:column property="labelTS" title="Creation time"
                  sortable="true" headerClass="sortable" />


  </display:table>

  <%--
     pagesize="${fn:length(result.rows) > preferences.pageLength ? preferences.pageLength : 0}">
  --%>
  <%--
  href="displayHardware.jsp" paramId="hardwareId"
  paramProperty="id"/>
  --%>
