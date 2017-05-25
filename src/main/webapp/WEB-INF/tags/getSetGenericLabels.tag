<%-- 
    Document   : getSetGenericLabels
    Created on : Nov. 14, 2016, 3:38 PM
    Author     : jrb
--%>

<%@tag description="get the labels that are currently applied to an object" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="preferences" uri="http://srs.slac.stanford.edu/preferences"%>

<%@attribute name="objectTypeId" required="true"%>
<%@attribute name="objectId" required="true"%>
<%@attribute name="fullHistory"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="genLabelQ" scope="AT_BEGIN"%>

<c:if test="${fullHistory != 'true'}"><c:set var="fullHistory" value="false"/></c:if>

<sql:query var="genLabelQ">
select L.name as labelName, L.id as theLabelId, LH.*, P.name as processName, 
  LG.name as labelGroupName, LG.id as labelGroupId
  from LabelHistory LH
  inner join Label L on L.id=LH.labelId
  inner join LabelGroup LG on LG.id=L.labelGroupId
  left join (Activity A
    inner join Process P on P.id=A.processId) on A.id=LH.activityId
where LH.id in (select 
<c:choose>
    <c:when test="${! fullHistory}">
        max(id)
    </c:when>
    <c:otherwise>
        id
    </c:otherwise>
</c:choose>
                from LabelHistory
                where objectId=?<sql:param value="${objectId}"/>
                and  labelableId=?<sql:param value="${objectTypeId}" />
                <c:if test="${! fullHistory}">group by labelId</c:if>)
<c:if test="${! fullHistory}">and LH.adding=1 </c:if>
and LG.labelableId=?<sql:param value="${objectTypeId}" /> 
order by LG.name, L.name, LH.id desc
;
</sql:query>
