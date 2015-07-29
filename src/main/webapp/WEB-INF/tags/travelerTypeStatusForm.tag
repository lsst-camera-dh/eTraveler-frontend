<%-- 
    Document   : travelerTypeStatusForm
    Created on : Apr 6, 2015, 11:10:09 AM
    Author     : focke
--%>

<%@tag description="A form to change the status of a TravelerType" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="travelerTypeId" required="true"%>

<traveler:fullRequestString var="thisPage"/>
<traveler:checkPerm var="mayWD" groups="EtravelerWorkflowDevelopers"/>
<traveler:checkPerm var="maySE" groups="EtravelerSubjectExperts"/>
<traveler:checkPerm var="maySoftMan" groups="EtravelerSoftwareManagers"/>
<traveler:checkPerm var="maySubsMan" groups="EtravelerSubsystemManagers"/>
<traveler:checkPerm var="mayQA" groups="EtravelerQualityAssurance"/>

<sql:query var="oldStateQ">
    select TTS.name
    from TravelerTypeState TTS
        inner join TravelerTypeStateHistory TTSH on TTSH.travelerTypeStateId=TTS.id
    where TTSH.travelerTypeId=?<sql:param value="${travelerTypeId}"/>
    order by TTSH.id desc limit 1;
</sql:query>
<c:set var="oldState" value="${oldStateQ.rows[0].name}"/>

<c:choose>
    <c:when test="${oldState == 'new'}">
        <h3>Next step is approval by a Workflow Developer (or Subsystem Manager for minor changes).</h3>
    </c:when>
    <c:when test="${oldState == 'workflowApproved'}">
        <h3>Next step is approval by a Subject Expert.</h3>
    </c:when>
    <c:when test="${oldState == 'subjectApproved'}">
        <h3>Next step is approval by a Software Manager.</h3>
    </c:when>
    <c:when test="${oldState == 'softwareApproved'}">
        <h3>Next step is approval by a Subsystem Manager.</h3>
    </c:when>
    <c:when test="${oldState == 'subsystemApproved'}">
        <h3>Next step is approval by QA.</h3>
    </c:when>
</c:choose>

<sql:query var="newStatesQ">
    select id, name, 1 as section
    from TravelerTypeState where name not in ('new', 'deactivated', ?<sql:param value="${oldState}"/>)
    union
    select id, name, 2 as section
    from TravelerTypeState where name='deactivated'
    order by section, name;
</sql:query>

<form action="approver/updateTravelerType.jsp" method="get">
    <input type="hidden" name="referringPage" value="${thisPage}">
    <input type="hidden" name="travelerTypeId" value="${travelerTypeId}">
    New Status:
    <c:set var="anyEnabled" value="false"/>
    <select name="stateId">
        <c:forEach var="newState" items="${newStatesQ.rows}">
            <c:if test="${(
                      (mayWD and oldState == 'new' and (newState.name == 'workflowApproved' or newState.name == 'deactivated'))
                      or (maySE and oldState == 'workflowApproved' and (newState.name == 'subjectApproved' or newState.name == 'deactivated'))
                      or (maySoftMan and oldState == 'subjectApproved' and (newState.name == 'softwareApproved' or newState.name == 'deactivated'))
                      or (maySubsMan and oldState == 'softwareApproved' and (newState.name == 'subsystemApproved' or newState.name == 'deactivated'))
                      or (mayQA and oldState == 'subsystemApproved' and (newState.name == 'active' or newState.name == 'deactivated'))
                  )
                  or (maySubsMan and oldState == 'new' and newState.name == 'active')
                  or (maySubsMan and newState.name == 'deactivated')
                  }">
                <c:set var="anyEnabled" value="true"/>
                <option value="${newState.id}"><c:out value="${newState.name}"/></option>
            </c:if>
        </c:forEach>
    </select>
    Reason:<textarea name='reason' required></textarea>
    <input type="submit" value="Update Traveler Type Status" <c:if test="${! anyEnabled}">disabled</c:if>>
</form>