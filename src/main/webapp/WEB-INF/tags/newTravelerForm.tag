<%-- 
    Document   : newTravelerForm.tag
    Created on : Jan 24, 2014, 2:51:15 PM
    Author     : focke
--%>

<%@tag description="Display a form to start a process traveler" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="hardwareTypeId"%>
<%@attribute name="hardwareGroupId"%>
<%@attribute name="processId"%>
<%@attribute name="hardwareId"%>

<c:set var="activeTravelerTypesOnly" value="true"/> <%-- should get this from user pref? --%>

<sql:query var="processQ" >
    select 
        P.id, concat(P.name, ' v', P.version) as versionedName
    from 
        Process P
        inner join TravelerType TT on TT.rootProcessId=P.id
        inner join TravelerTypeStateHistory TTSH on 
            TTSH.travelerTypeId=TT.id 
            and TTSH.id=(select max(id) from TravelerTypeStateHistory where travelerTypeId=TT.id)
        inner join TravelerTypeState TTS on TTS.id=TTSH.travelerTypeStateId
        <c:if test="${(!empty hardwareTypeId) or (!empty hardwareId)}">
            inner join HardwareTypeGroupMapping HTGM on HTGM.hardwareGroupId=P.hardwareGroupId
        </c:if>
        <c:if test="${(empty hardwareTypeId) and (!empty hardwareId)}">
            inner join Hardware H on H.hardwareTypeId=HTGM.hardwareTypeId
        </c:if>
    where 
    <c:choose>
        <c:when test="${!empty processId}">
    P.id=?<sql:param value="${processId}"/>           
        </c:when>
        <c:when test="${!empty hardwareGroupId}">
    P.hardwareGroupId=?<sql:param value="${hardwareGroupId}"/>
        </c:when>
        <c:when test="${!empty hardwareTypeId}">
    HTGM.hardwareTypeId=?<sql:param value="${hardwareTypeId}"/>
        </c:when>
        <c:when test="${!empty hardwareId}">
    H.id=?<sql:param value="${hardwareId}"/>
        </c:when>
        <c:otherwise>
    false <%-- otherwise it will list all hardware and procs if called with no attributes --%>
        </c:otherwise>
    </c:choose>
    <c:if test="${activeTravelerTypesOnly}">
        and TTS.name='active'
    </c:if>
    order by P.name
    ;
</sql:query>
    
<sql:query var="hardwareQ" >
    select H.id, H.lsstId
    from Hardware H
    <c:if test="${(!empty hardwareGroupId) or (!empty processId)}">
        inner join HardwareTypeGroupMapping HTGM on HTGM.hardwareTypeId=H.hardwareTypeId
    </c:if>
    <c:if test="${(empty hardwareGroupId) and (!empty processId)}">
        inner join Process P on P.hardwareGroupId=HTGM.hardwareGroupId
    </c:if>
    inner join HardwareStatusHistory HSH on HSH.hardwareId=H.id and HSH.id=(select max(id) from HardwareStatusHistory where hardwareId=H.id)
    inner join HardwareStatus HS on HS.id=HSH.hardwareStatusId
    where 
    HS.name not in ('REJECTED', 'USED', 'PENDING')
    and
    <c:choose>
        <c:when test="${!empty hardwareId}">
    H.id=?<sql:param value="${hardwareId}"/>  
        </c:when>
        <c:when test="${!empty hardwareTypeId}">
    H.hardwareTypeId=?<sql:param value="${hardwareTypeId}"/>
        </c:when>
        <c:when test="${!empty hardwareGroupId}">
    HTGM.hardwareGroupId=?<sql:param value="${hardwareGroupId}"/>
        </c:when>
        <c:when test="${!empty processId}">
    P.id=?<sql:param value="${processId}"/>
        </c:when>
        <c:otherwise>
    false <%-- otherwise it will list all hardware and procs if called with no attributes --%>
        </c:otherwise>
    </c:choose>
    order by H.lsstId
    ;
</sql:query>
   
<form METHOD=GET ACTION="fh/createTraveler.jsp">
    <input type="hidden" name="inNCR" value="FALSE">
    <table>
        <tr>
            <td>
    Traveler Type:
            </td>
            <td>
    <c:choose>
        <c:when test="${empty processId}">
            <select name="processId">
                <c:forEach var="pRow" items="${processQ.rows}">
                    <option value="${pRow.id}">${pRow.versionedName}</option>
                </c:forEach>
            </select>
        </c:when>
        <c:otherwise>
            <input type="hidden" name="processId" value="${processQ.rows[0].id}">
            <c:out value="${processQ.rows[0].versionedName}"/>
        </c:otherwise>
    </c:choose>
            </td>
        </tr>
        <tr>
            <td>
    Component:
            </td>
            <td>
    <c:choose>
        <c:when test="${empty hardwareId}">
            <select name="hardwareId">
                <c:forEach var="hRow" items="${hardwareQ.rows}">
                    <option value="${hRow.id}">${hRow.lsstId}</option>
                </c:forEach>
            </select>
        </c:when>
        <c:otherwise>
            <input type="hidden" name="hardwareId" value="${hardwareQ.rows[0].id}">
            <c:out value="${hardwareQ.rows[0].lsstId}"/>
        </c:otherwise>
    </c:choose>
            </td>
        </tr>
    </table>
    <INPUT TYPE=SUBMIT value="Initiate Traveler">
</form>
