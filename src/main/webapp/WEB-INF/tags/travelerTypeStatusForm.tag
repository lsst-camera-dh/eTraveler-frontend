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

<traveler:checkPerm var="maySupervise" groups="EtravelerSupervisor"/>
<traveler:checkPerm var="mayApprove" groups="EtravelerApprover"/>
<traveler:checkPerm var="mayQA" groups="EtravelerQualityAssurance"/>
<c:set var="mayDeact" value="${mayApprove}"/>

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
        <h3>Next step is approval by a supervisor.</h3><br>
    </c:when>
    <c:when test="${oldState == 'validated'}">
        <h3>Next step is approval by an approver.</h3><br>
    </c:when>
    <c:when test="${oldState == 'approved'}">
        <h3>Next step is approval by QA.</h3><br>
    </c:when>
</c:choose>

<sql:query var="newStatesQ">
    select id, name from TravelerTypeState where name not in ('new', ?<sql:param value="${oldState}"/>)
    order by name;
</sql:query>

<form action="approver/updateTravelerType.jsp" method="get">
    <input type="hidden" name="travelerTypeId" value="${travelerTypeId}">
    New Status:
    <c:set var="anyEnabled" value="false"/>
    <select name="stateId">
        <c:forEach var="newState" items="${newStatesQ.rows}">
            <c:if test="${
                  (maySupervise and oldState == 'new' and newState.name == 'validated')
                  or (mayApprove and oldState == 'validated' and newState.name == 'approved')
                  or (mayQA and oldState == 'approved' and newState.name == 'active')
                  or (mayDeact and newState.name == 'deactivated')
                  }">
                <c:set var="anyEnabled" value="true"/>
                <option value="${newState.id}"><c:out value="${newState.name}"/></option>
            </c:if>
        </c:forEach>
    </select>
    Reason:<textarea name='reason'></textarea>
    <input type="submit" value="Update Traveler Type Status" <c:if test="${! anyEnabled}">disabled</c:if>>
</form>