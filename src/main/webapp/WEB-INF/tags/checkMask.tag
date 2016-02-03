<%-- 
    Document   : checkMask
    Created on : Jun 11, 2015, 12:45:52 PM
    Author     : focke
--%>

<%@tag description="Check the user's groups against a bitmask obtained from a process" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId"%>
<%@attribute name="processId"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="hasPerm" scope="AT_BEGIN"%>

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
        <c:if test="${empty processId}">
            <c:if test="${empty activityId}">
                <traveler:error message="Incomplete arguments to checkMask" bug="true"/>
            </c:if>
            <sql:query var="processQ">
select processId from Activity where id=?<sql:param value="${activityId}"/>
            </sql:query>
            <c:set var="processId" value="${processQ.rows[0].processId}"/>
        </c:if>

        <sql:query var="rolesQ">
select PG.name
from Process P
inner join PermissionGroup PG on (PG.maskBit & P.permissionMask)!=0
where P.id=?<sql:param value="${processId}"/>
;
        </sql:query>

        <%-- Is the user in an allowed group? --%>
        <c:set var="hasPerm" value="false"/>
        <c:forEach var="role" items="${rolesQ.rows}">
            <c:if test="${! hasPerm}">
                <traveler:checkSsPerm var="hasPerm" activityId="${activityId}" processId="${processId}" roles="${role.name}"/>
            </c:if>
    </c:forEach>
    </c:otherwise>
</c:choose>
