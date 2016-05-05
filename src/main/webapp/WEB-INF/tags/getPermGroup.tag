<%-- 
    Document   : getPermGroup
    Created on : May 5, 2016, 3:32:08 PM
    Author     : focke
--%>

<%@tag description="Get the group manager group given a subsystem and role" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="subsystem" required="true"%>
<%@attribute name="role" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="groupName" scope="AT_BEGIN"%>

<c:choose>
    <c:when test="${subsystem == 'Legacy' || subsystem =='Default'}">
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
            <c:when test="${role == 'softwareManager'}">
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
        <c:set var="groupName" value="${subsystem}_${role}"/>
    </c:otherwise>
</c:choose>
