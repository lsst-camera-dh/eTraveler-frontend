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
        <c:choose>
            <c:when test="${! empty subsystemId}">
                <sql:query var="subsysQ">
select SS.shortName
from Subsystem SS
where id=?<sql:param value="${subsystemId}"/>
;
                </sql:query>
            </c:when>
            <c:when test="${! empty activityId}">
                <traveler:findTraveler var="travelerId" activityId="${activityId}"/>
                <sql:query var="subsysQ">
select SS.shortName
from Activity A
inner join TravelerType TT on TT.rootProcessId=A.processId
inner join Subsystem SS on SS.id=TT.subsystemId
where A.id=?<sql:param value="${travelerId}"/>
;
                </sql:query>
            </c:when>
            <c:when test="${! empty travelerTypeId}">
                <sql:query var="subsysQ">
select SS.shortName
from TravelerType TT
inner join Subsystem SS on SS.id=TT.subsystemId
where TT.id=?<sql:param value="${travelerTypeId}"/>
;
                </sql:query>
            </c:when>
            <c:when test="${! empty processId}">
                <sql:query var="subsysQ">
select SS.shortName
from TravelerType TT
inner join Subsystem SS on SS.id=TT.subsystemId
where TT.rootProcessId=?<sql:param value="${processId}"/>
;
                </sql:query>
                <c:if test="${empty subsysQ.rows}">
                    <traveler:error message="checkSsPerm called with non-root process ${processId}" bug="true"/>
                </c:if>
            </c:when>
            <c:when test="${! empty hardwareId}">
                <sql:query var="subsysQ">
select SS.shortName 
from Hardware H
inner join HardwareType HT on HT.id=H.hardwareTypeId
inner join Subsystem SS on SS.id=HT.subsystemId
where H.id=?<sql:param value="${hardwareId}"/>
;
                </sql:query>
            </c:when>
            <c:when test="${! empty hardwareTypeId}">
                <sql:query var="subsysQ">
select SS.shortName 
from HardwareType HT
inner join Subsystem SS on SS.id=HT.subsystemId
where HT.id=?<sql:param value="${hardwareTypeId}"/>
;
                </sql:query>
            </c:when>
            <c:otherwise>
                <traveler:error message="Insufficient arguments to checkSsPerm" bug="true"/>
            </c:otherwise>
        </c:choose>
        <c:set var="subsystemName" value="${subsysQ.rows[0].shortName}"/>

        <%-- Is the user in an allowed group? --%>
        <c:set var="hasPerm" value="false"/>
        <c:forTokens var="role" items="${roles}" delims=",">
            <c:if test="${! hasPerm}">
                <c:choose>
                    <c:when test="${subsystemName == 'Legacy' || subsystemName =='Default'}">
                        <c:choose>
                            <c:when test="${role == 'admin'}">
                                <c:set var="groupName" value="EtravelerAdmin"/>
                            </c:when>
                            <c:when test="${role == 'approver'}">
                                <c:set var="groupName" value="EtravelerApprover"/>
                            </c:when>
                            <c:when test="${role == 'operator'}">
                                <c:set var="groupName" value="EtravelerOperator"/>
                            </c:when>
                            <c:when test="${role == 'qualityAssurance'}">
                                <c:set var="groupName" value="EtravelerQualityAssurance"/>
                            </c:when>
                            <c:when test="${role == 'softwareManger'}">
                                <c:set var="groupName" value="EtravelerSoftwareManagers"/>
                            </c:when>
                            <c:when test="${role == 'subjectExpert'}">
                                <c:set var="groupName" value="EtravelerSubjectExperts"/>
                            </c:when>
                            <c:when test="${role == 'subsystemManager'}">
                                <c:set var="groupName" value="EtravelerSubsystemManagers"/>
                            </c:when>
                            <c:when test="${role == 'supervisor'}">
                                <c:set var="groupName" value="EtravelerSupervisor"/>
                            </c:when>
                            <c:when test="${role == 'workflowDeveloper'}">
                                <c:set var="groupName" value="EtravelerWorkflowDevelopers"/>
                            </c:when>
                            <c:otherwise>
                                <traveler:error message="bad role [${role}]"/>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <c:set var="groupName" value="${subsystemName}_${role}"/>
                    </c:otherwise>
                </c:choose>
                <traveler:checkPerm var="hasPerm" groups="${groupName}"/>
            </c:if>
        </c:forTokens>
    </c:otherwise>
</c:choose>
