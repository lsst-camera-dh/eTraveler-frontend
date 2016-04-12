<%-- 
    Document   : limsDefineHardwareType
    Created on : Nov 12, 2015, 11:21:11 AM
    Author     : focke
--%>

<%@tag description="Add a new HardwareType from scripting API" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<c:choose>
    <c:when test="${empty inputs.subsystemId}">
        <c:set var="subsystemName" value="${empty inputs.subsystem ? 'Default' : inputs.subsystem}"/>
        <sql:query var="subsysQ">
select id from Subsystem where shortName=?<sql:param value="${subsystemName}"/>;
        </sql:query>
        <c:set var="subsystemId" value="${subsysQ.rows[0].id}"/>
    </c:when>
    <c:otherwise>
        <c:set var="subsystemId" value="${inputs.subsystemId}"/>
    </c:otherwise>
</c:choose>

<ta:createHardwareType var="hardwareTypeId" name="${inputs.name}" subsystemId="${subsystemId}"
                       width="${inputs.sequenceWidth}" isBatched="${inputs.batchedFlag}"
                       description="${inputs.description}"/>

{"id": ${hardwareTypeId}, "acknowledge": null}
