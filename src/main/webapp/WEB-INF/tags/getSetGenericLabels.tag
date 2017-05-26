<%-- 
    Document   : getSetGenericLabels
    Created on : Nov. 14, 2016, 3:38 PM
    Author     : jrb
--%>

<%@tag description="get the labels that are currently applied to an object" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="preferences" uri="http://srs.slac.stanford.edu/preferences"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="objectTypeId"%>
<%@attribute name="objectId"%>
<%@attribute name="labelGroupId"%>
<%@attribute name="labelId"%>
<%@attribute name="fullHistory"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="genLabelQ" scope="AT_BEGIN"%>

<c:if test="${fullHistory != 'true'}"><c:set var="fullHistory" value="false"/></c:if>

<c:choose>
    <c:when test="${! empty objectTypeId && ! empty objectId}">
        <c:set var="mode" value="object"/>
    </c:when>
    <c:when test="${! empty labelGroupId}">
        <c:set var="mode" value="group"/>
    </c:when>
    <c:when test="${! empty labelId}">
        <c:set var="mode" value="label"/>
    </c:when>
    <c:otherwise>
        <traveler:error message="Insufficient arguments to getSetGenericLabels" bug="true"/>
    </c:otherwise>
</c:choose>

<sql:query var="genLabelQ">
select L.name as labelName, L.id as theLabelId, LH.*, P.name as processName, 
  LG.name as labelGroupName, LG.id as labelGroupId
  from LabelHistory LH
  inner join Label L on L.id=LH.labelId
  inner join LabelGroup LG on LG.id=L.labelGroupId
  left join (Activity A
    inner join Process P on P.id=A.processId) on A.id=LH.activityId
where LH.id in (select 
    ${fullHistory ? 'LH2.id' : 'max(LH2.id)'}
    from LabelHistory LH2
    <c:if test="${mode == 'group'}">inner join Label L2 on L2.id = LH2.labelId</c:if>
    where 
    <c:choose>
        <c:when test="${mode == 'object'}">
            LH2.objectId=?<sql:param value="${objectId}"/>
            and LH2.labelableId=?<sql:param value="${objectTypeId}" />
        </c:when>
        <c:when test="${mode == 'group'}">
            L2.labelGroupId = ?<sql:param value="${labelGroupId}"/>
        </c:when>
        <c:when test="${mode == 'label'}">
            LH2.labelId = ?<sql:param value="${labelId}"/>
        </c:when>
    </c:choose>
    <c:if test="${! fullHistory}">group by 
        <c:choose>
            <c:when test="${mode == 'object'}">
                LH2.labelId
            </c:when>
            <c:when test="${mode == 'group'}">
                LH2.objectId, LH2.labelId
            </c:when>
            <c:when test="${mode == 'label'}">
                LH2.objectId
            </c:when>
        </c:choose>
    </c:if>)
<c:if test="${! fullHistory}">and LH.adding=1 </c:if>
order by LG.name, L.name, LH.id desc
;
</sql:query>
