<%-- 
    Document   : checkSsPerm
    Created on : Jun 2, 2015, 4:59:09 PM
    Author     : focke
--%>

<%@tag description="Check permissions against subsystem determined from some argument and supplied list of roles" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="subsystemId"%>
<%@attribute name="activityId"%>
<%@attribute name="travelerTypeId"%>
<%@attribute name="processId"%>
<%@attribute name="hardwareId"%>
<%@attribute name="hardwareTypeId"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="hasPerm" scope="AT_BEGIN"%>
<%@attribute name="roles" required="true"%>

<%-- Is the dataSourceMode protected? --%>
<c:set var="inAMode" value="false"/>
<c:forTokens var="mode" items="${appVariables.etravelerProtectedModes}" delims=",">
    <c:if test="${appVariables.dataSourceMode == mode}">
        <c:set var="inAMode" value="true"/>
    </c:if>    
</c:forTokens>

<c:choose>
    <c:when test="${! preferences.writeable}">
        <c:set var="hasPerm" value="false"/>
    </c:when>
    <c:when test="${! inAMode}">
        <c:set var="hasPerm" value="true"/>
    </c:when>
    <c:otherwise>
        <traveler:getSsName var="subsystemName" subsystemId="${subsystemId}"
                            activityId="${activityId}" 
                            travelerTypeId="${travelerTypeId}" 
                            processId="${processId}" 
                            hardwareId="${hardwareId}" 
                            hardwareTypeId="${hardwareTypeId}"/>

        <%-- Is the user in an allowed group? --%>
        <c:set var="hasPerm" value="false"/>
        <c:forTokens var="role" items="${roles}" delims=",">
            <c:if test="${! hasPerm}">
                <traveler:getPermGroup var="groupName" subsystem="${subsystemName}" role="${role}"/>
                <traveler:checkPerm var="hasPerm" groups="${groupName}"/>
            </c:if>
        </c:forTokens>
    </c:otherwise>
</c:choose>
