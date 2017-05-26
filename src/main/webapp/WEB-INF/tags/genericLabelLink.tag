<%-- 
    Document   : genericLabelLink
    Created on : May 26, 2017, 3:29:33 PM
    Author     : focke
--%>

<%@tag description="given a label history id, produce a link to the labeled object" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="labelHistoryId"%>

    <sql:query var="labelableQ">
select LA.name 
from LabelHistory LH
inner join Labelable LA on LA.id = LH.labelableId
where LH.id = ?<sql:param value="${labelHistoryId}"/>
    </sql:query>
<c:set var="type" value="${labelableQ.rows[0].name}"/>

<c:choose>
    <c:when test="${type == 'run'}">
        <sql:query var="objectQ">
select A.id as objectId, P.name as objectName
from LabelHistory LH
inner join RunNumber RN on RN.id = LH.objectId
inner join Activity A on A.id = RN.rootActivityId
inner join Process P on P.id = A.processId
where LH.id = ?<sql:param value="${labelHistoryId}"/>;
        </sql:query>
        <c:set var="page" value="displayActivity.jsp"/>
        <c:set var="paramName" value="activityId"/>
    </c:when>
    <c:when test="${type == 'hardware'}">
        <sql:query var="objectQ">
select H.id as objectId, H.lsstId as objectName
from LabelHistory LH
inner join Hardware H on H.id = LH.objectId
where LH.id = ?<sql:param value="${labelHistoryId}"/>;
        </sql:query>
        <c:set var="page" value="displayHardware.jsp"/>
        <c:set var="paramName" value="hardwareId"/>
    </c:when>
    <c:when test="${type == 'hardwareType'}">
        <sql:query var="objectQ">
select HT.id as objectId, HT.name as objectName
from LabelHistory LH
inner join HardwareType HT on HT.id = LH.objectId
where LH.id = ?<sql:param value="${labelHistoryId}"/>;
        </sql:query>
        <c:set var="page" value="displayHardwareType.jsp"/>
        <c:set var="paramName" value="hardwareTypeId"/>
    </c:when>
    <c:when test="${type == 'NCR'}">
        <sql:query var="objectQ">
select A.id as objectId, P.name as objectName
from LabelHistory LH
inner join Exception E on E.id = LH.objectId
inner join Activity A on A.id = E.NCRActivityId
inner join Process P on P.id = A.processId
where LH.id = ?<sql:param value="${labelHistoryId}"/>;
        </sql:query>
        <c:set var="page" value="displayActivity.jsp"/>
        <c:set var="paramName" value="activityId"/>
    </c:when>
    <c:when test="${type == 'travelerType'}">
        <sql:query var="objectQ">
select TT.id as objectId, P.name as objectName
from LabelHistory LH
inner join TravelerType TT on TT.id = LH.objectId
inner join Process P on P.id = TT.rootProcessId
where LH.id = ?<sql:param value="${labelHistoryId}"/>;
        </sql:query>
        <c:set var="page" value="displayTravelerType.jsp"/>
        <c:set var="paramName" value="travelerTypeId"/>
    </c:when>
    <c:when test="${type == 'label'}">
        <sql:query var="objectQ">
select L.id as objectId, L.name as objectName
from LabelHistory LH
inner join Label L on L.id = LH.objectId
where LH.id = ?<sql:param value="${labelHistoryId}"/>;
        </sql:query>
        <c:set var="page" value="displayLabel.jsp"/>
        <c:set var="paramName" value="labelId"/>
    </c:when>
</c:choose>
<c:set var="object" value="${objectQ.rows[0]}"/>

<c:url var="objectLink" value="${page}">
    <c:param name="${paramName}" value="${object.objectId}"/>
</c:url>

<a href="${objectLink}">${object.objectName}</a>
