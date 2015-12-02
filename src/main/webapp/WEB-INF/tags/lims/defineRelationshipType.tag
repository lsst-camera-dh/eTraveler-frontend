<%-- 
    Document   : defineHardwareRelationship
    Created on : Dec 1, 2015, 1:53:53 PM
    Author     : focke
--%>

<%@tag description="Define a new HardwareRelationshipType via the API" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<c:choose>
    <c:when test="${! empty inputs.hardwareTypeName}">
        <sql:query var="hardwareTypeQ">
select id from HardwareType where name=?<sql:param value="${inputs.hardwareTypeName}"/>
        </sql:query>
        <c:if test="${empty hardwareTypeQ.rows}">
            <traveler:error message="No hardware type with name ${inputs.hardwareTypeName} found."/>
        </c:if>
        <c:set var="hardwareTypeId" value="${hardwareTypeQ.rows[0].id}"/>
        <c:if test="${! empty inputs.hardwareTypeId && hardwareTypeId != inputs.hardwareTypeId}">
            <traveler:error message="Input hardware type name (${inputs.hardwareTypeName}) and id (${inputs.hardwareTypeId}) don't match."/>
        </c:if>
    </c:when>
    <c:otherwise>
        <c:set var="hardwareTypeId" value="${inputs.hardwareTypeId}"/>
    </c:otherwise>
</c:choose>

<c:choose>
    <c:when test="${! empty inputs.minorTypeName}">
        <sql:query var="minorTypeQ">
select id from HardwareType where name=?<sql:param value="${inputs.minorTypeName}"/>
        </sql:query>
        <c:if test="${empty minorTypeQ.rows}">
            <traveler:error message="No hardware type with name ${inputs.minorTypeName} found."/>
        </c:if>
        <c:set var="minorTypeId" value="${minorTypeQ.rows[0].id}"/>
        <c:if test="${! empty inputs.minorTypeId && minorTypeId != inputs.minorTypeId}">
            <traveler:error message="Input minor type name (${inputs.minorTypeName}) and id (${inputs.minorTypeId}) don't match."/>
        </c:if>
    </c:when>
    <c:otherwise>
        <c:set var="minorTypeId" value="${inputs.minorTypeId}"/>
    </c:otherwise>
</c:choose>

<ta:createRelationshipType slotNames="${inputs.slotNames}" minorTypeId="${minorTypeId}"
    numItems="${inputs.numItems}" name="${inputs.name}" hardwareTypeId="${hardwareTypeId}"
    description="${inputs.description}"/>

{"acknowledge": null}
