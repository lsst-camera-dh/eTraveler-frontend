<%-- 
    Document   : compOfRows
    Created on : Apr 9, 2013, 2:01:16 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="hardwareId"%>

<sql:query var="componentOfQ" dataSource="jdbc/rd-lsst-cam">
    select HR.hardwareId, HR.begin, HR.end, HRT.name as relationshipName, HT.name as hardwareName, H.lsstId
    from HardwareRelationship HR, HardwareRelationshipType HRT, HardwareType HT, Hardware H
    where 
    HR.componentId=?<sql:param value="${hardwareId}"/>
    and 
    HR.hardwareRelationshipTypeId=HRT.id
    and 
    HT.id=H.typeId
    and 
    H.id=HR.hardwareId
    and 
    HR.end is null;
</sql:query>

<c:forEach var="coRow" items="${componentOfQ.rows}">
    <%-- Really only expecting 0 or 1 here. --%>
    <tr>
        <c:url value="displayHardware.jsp" var="hwLink">
            <c:param name="hardwareId" value="${coRow.hardwareId}"/>
        </c:url>
        <td><a href="${hwLink}">${coRow.lsstId}</a></td>
        <td>${coRow.hardwareName}</td>
        <td>${coRow.begin}</td>
        <td>${coRow.relationshipName}</td>
    </tr>
    <traveler:compOfRows hardwareId="${coRow.hardwareId}"/>
</c:forEach>