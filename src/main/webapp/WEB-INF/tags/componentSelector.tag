<%-- 
    Document   : componentSelector
    Created on : Aug 9, 2013, 4:06:44 PM
    Author     : focke
--%>

<%@tag description="Pick a component" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="status"%>

<c:if test="${empty status}">
    <c:set var="status" value="READY"/>
</c:if>

<sql:query var="potentialComponentsQ" >
    select H.id, H.lsstId, HT.name 
    from Activity A
    inner join Process P on P.id=A.processId
    inner join HardwareRelationshipType HRT on HRT.id=P.hardwareRelationshipTypeId
    inner join HardwareType HT on HT.id=HRT.componentTypeId
    inner join Hardware H on H.hardwareTypeId=HT.id
    inner join HardwareStatusHistory HSH on HSH.hardwareId=H.id and HSH.id=(select max(id) from HardwareStatusHistory where hardwareId=H.id)
    left join HardwareRelationship HR on HR.componentId=H.id
    where HSH.hardwareStatusId=(select id from HardwareStatus where name=?<sql:param value="${status}"/>)
    and (HR.end is not null or HR.id is null)
    and A.id=?<sql:param value="${activityId}"/>
    order by H.lsstId;
</sql:query>

<c:choose>
    <c:when test="${empty potentialComponentsQ.rows}">
        We're out.
        <c:set var="gotSomeComponents" value="false" scope="request"/>
    </c:when>
    <c:otherwise>
        <c:set var="gotSomeComponents" value="true" scope="request"/>
        <select name="componentId">
            <c:forEach var="hRow" items="${potentialComponentsQ.rows}">
                <option value="${hRow.id}">${hRow.lsstId}</option>
            </c:forEach>
        </select>
    </c:otherwise>
</c:choose>
