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

<%@attribute name="activityId" required="true"%>
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
        <traveler:findTraveler var="travelerId" activityId="${activityId}"/>
        <sql:query var="subsysQ">
select SS.shortName
from Activity A
left join TravelerType TT on TT.rootProcessId=A.processId
inner join Subsystem SS on SS.id=TT.subsystemId
where A.id=?<sql:param value="${travelerId}"/>
;
        </sql:query>
        <c:set var="subsysName" value="${subsysQ.rows[0].shortName}"/>

        <sql:query var="rolesQ">
select PG.name
from Activity A
inner join Process P on P.id=A.processId
inner join PermissionGroup PG on (PG.maskBit & P.permissionMask)!=0
where A.id=?<sql:param value="${activityId}"/>
;
        </sql:query>

        <%-- Is the user in an allowed group? --%>
        <c:set var="hasPerm" value="false"/>
        <c:forEach var="role" items="${rolesQ.rows}">
            <c:if test="${! hasPerm}">
                <c:set var="groupName" value="${subsysName}_${role.name}"/>
                <c:if test="${gm:isUserInGroup(pageContext, groupName)}">
                    <c:set var="hasPerm" value="true"/>
                </c:if>
            </c:if>
    </c:forEach>
    </c:otherwise>
</c:choose>
