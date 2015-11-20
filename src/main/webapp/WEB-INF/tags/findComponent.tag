<%-- 
    Document   : findComponent
    Created on : Nov 19, 2015, 3:16:46 PM
    Author     : focke
--%>

<%@tag description="Find id of component given serial number." pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="serial"%>
<%@attribute name="typeName"%>
<%@attribute name="inputId"%>
<%@attribute name="groupName"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="hardwareId" scope="AT_BEGIN"%>

<c:choose>
    <c:when test="${! empty serial}">
        <c:if test="${empty typeName}">
            <traveler:error message="If you supply a serial number, you must also supply hardware type."/>
        </c:if>
        <sql:query var="hwIdQ">
select H.id 
from Hardware H
inner join HardwareType HT on HT.id=H.hardwareTypeId
where H.lsstId=?<sql:param value="${serial}"/>
and HT.name=?<sql:param value="${typeName}"/>
;
        </sql:query>
        <c:if test="${empty hwIdQ.rows}">
            <traveler:error message="No component with serial number ${serial} of type ${typeName}."/>
        </c:if>
        <c:set var="hardwareId" value="${hwIdQ.rows[0].id}"/>
        <c:if test="${! empty inputId && hardwareId != inputId}">
            <traveler:error message="Serial number ${serial} has hardwareId ${hardwareId}, does not match input id ${inputId}"/>            
        </c:if>
    </c:when>
    <c:otherwise>
        <c:if test="${empty inputId}">
            <traveler:error message="You must supply either serial number or hardwareId."/>
        </c:if>
        <c:set var="hardwareId" value="${inputId}"/>
    </c:otherwise>
</c:choose>

<c:if test="${! empty groupName}">
    <sql:query var="groupQ">
select id from HardwareGroup where name=?<sql:param value="${groupName}"/>;
    </sql:query>
<c:if test="${empty groupQ.rows}">
    <traveler:error message="Bad hardware group name ${groupName}."/>
</c:if>
<c:set var="hardwareGroupId" value="${groupQ.rows[0].id}"/>
    
    <sql:query var="inGroupQ">
select H.id
from Hardware H
inner join HardwareType HT on HT.id=H.hardwareTypeId
inner join HardwareTypeGroupMapping HTGM on HTGM.hardwareTypeId=HT.id
where H.id=?<sql:param value="${hardwareId}"/>
and HTGM.hardwareGroupId=?<sql:param value="${hardwareGroupId}"/>
;
    </sql:query>
    <c:if test="${empty inGroupQ.rows}">
        <traveler:error message="Component ${hardwareId} is not in group ${groupName}."/>
    </c:if>
</c:if>
