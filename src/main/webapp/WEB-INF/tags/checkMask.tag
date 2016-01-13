<%-- 
    Document   : checkMask
    Created on : Jun 11, 2015, 12:45:52 PM
    Author     : focke
--%>

<%@tag description="Check the user's groups against a bitmask" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="gm" uri="http://srs.slac.stanford.edu/GroupManager"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId"%>
<%@attribute name="processId"%>
<%@attribute name="hardwareId"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="hasPerm" scope="AT_BEGIN"%>

<c:choose>
    <c:when test="${! empty activityId}">
        <sql:query var="activityQ">
select processId, hardwareId from Activity where id=?<sql:param value="${activityId}"/>
        </sql:query>
        <c:set var="processId" value="${activityQ.rows[0].processId}"/>
        <c:set var="hardwareId" value="${activityQ.rows[0].hardwareId}"/>
    </c:when>
    <c:otherwise>
        <c:if test="${empty processId or empty hardwareId}">
            <traveler:error message="Incomplete checkMask arguments" bug="true"/>
        </c:if>
    </c:otherwise>
</c:choose>

    <sql:query var="groupsQ">
select concat(SS.shortName, '_', PG.name) as name
from Process P
inner join PermissionGroup PG on (PG.maskBit & P.permissionMask)!=0
cross join Hardware H
inner join HardwareType HT on HT.id=H.hardwareTypeId
inner join Subsystem SS on SS.id=HT.subsystemId
where P.id=?<sql:param value="${processId}"/>
and H.id=?<sql:param value="${hardwareId}"/>
;
    </sql:query>

<%-- Is the user in an allowed group? --%>
<c:set var="inAGroup" value="false"/>
<c:forEach var="group" items="${groupQ.rows}">
    <c:if test="${gm:isUserInGroup(pageContext, group.name)}">
        <c:set var="inAGroup" value="true"/>
    </c:if>
</c:forEach>

<%-- Is the dataSourceMode protected? --%>
<c:set var="inAMode" value="false"/>
<c:forTokens var="mode" items="${appVariables.etravelerProtectedModes}" delims=",">
    <c:if test="${appVariables.dataSourceMode == mode}">
        <c:set var="inAMode" value="true"/>
    </c:if>    
</c:forTokens>

<c:set var="hasPerm" value="${preferences.writeable
                              &&
                              (inAGroup || !inAMode)}"/>
