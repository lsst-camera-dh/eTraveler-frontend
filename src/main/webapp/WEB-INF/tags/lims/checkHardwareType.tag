<%-- 
    Document   : checkHardwareType
    Created on : Dec 2, 2015, 1:35:24 PM
    Author     : focke
--%>

<%@tag description="Verify HardwareType, return id." pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="inputTypeId" required="true"%>
<%@attribute name="inputTypeName" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="hardwareTypeId" scope="AT_BEGIN"%>

<c:choose>
    <c:when test="${! empty inputTypeName}">
        <sql:query var="hardwareTypeQ">
select id from HardwareType where name=?<sql:param value="${inputTypeName}"/>
        </sql:query>
        <c:if test="${empty hardwareTypeQ.rows}">
            <traveler:error message="No hardware type with name ${inputTypeName} found."/>
        </c:if>
        <c:set var="hardwareTypeId" value="${hardwareTypeQ.rows[0].id}"/>
        <c:if test="${! empty inputTypeId && hardwareTypeId != inputTypeId}">
            <traveler:error message="Input hardware type name (${inputTypeName}) and id (${inputTypeId}) don't match."/>
        </c:if>
    </c:when>
    <c:when test="${! empty inputTypeId}">
        <sql:query var="typeIdQ">
select id from HardwareType where id=?<sql:param value="${inputTypeId}"/>
        </sql:query>
        <c:if test="empty typeIdQ.rows">
            <traveler:error message="No hardware type with id ${inputTypeId} found."/>
        </c:if>
        <c:set var="hardwareTypeId" value="${inputTypeId}"/>
    </c:when>
    <c:otherwise>
        <traveler:error message="You must supply a hardware type name or id."/>
    </c:otherwise>
</c:choose>

