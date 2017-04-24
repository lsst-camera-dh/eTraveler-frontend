<%-- 
    Document   : getSetGenericLabels
    Created on : Nov. 14, 2016, 3:38 PM
    Author     : jrb
--%>

<%@tag description="get the labels that are currently applied to an object" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="objectTypeId" required="true"%>
<%@attribute name="objectId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="labelQ" scope="AT_BEGIN"%>




<sql:query var="genLabelQ">
select L.name as labelName, L.id as labelId, LH.*, P.name as processName
  from LabelHistory LH
  inner join Label L on L.id=LH.labelId
  inner join LabelGroup LG on LG.id=L.labelGroupId
  left join (Activity A
    inner join Process P on P.id=A.processId) on A.id=LH.activityId
where LH.id in (select max(id)
                from LabelHistory
                where LH.objectId=?<sql:param value="${objectId}"/>
                and  LG.labelableId=?<sql:param value="${objectTypeId}" />
                group by labelId)
and LH.adding=1
<%--
<c:if test="${! empty subsysIdQ}">
  and LG.subsystemId=?<sql:param value="${subsysId}" />
  or LG.subsystemId="" />
</c:if>
--%>
<%-- and need to do similar filtering on hardware groups --%>
  order by LH.id desc
;
</sql:query>
