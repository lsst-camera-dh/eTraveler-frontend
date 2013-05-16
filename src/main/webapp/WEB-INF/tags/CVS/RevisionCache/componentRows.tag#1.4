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

<sql:query var="componentsQ" dataSource="jdbc/rd-lsst-cam">
    select HR.componentId, HR.begin, HR.end, HRT.name as relationshipName, HT.name as hardwareName, H.lsstId
    from HardwareRelationship HR, HardwareRelationshipType HRT, HardwareType HT, Hardware H
    where 
    HR.hardwareId=?<sql:param value="${hardwareId}"/>
    and 
    HR.hardwareRelationshipTypeId=HRT.id
    and 
    HT.id=H.typeId
    and 
    H.id=HR.componentId
    and 
    HR.end is null;
</sql:query>

<c:forEach var="cRow" items="${componentsQ.rows}">
    <tr>
        <c:url value="displayHardware.jsp" var="hwLink">
            <c:param name="hardwareId" value="${cRow.componentId}"/>
        </c:url>
        <td><a href="${hwLink}">${cRow.lsstId}</a></td>
        <td>${cRow.hardwareName}</td>
        <td>${cRow.begin}</td>
        <td>${cRow.relationshipName}</td>
    </tr>
    <traveler:componentRows hardwareId="${cRow.componentId}"/>
</c:forEach>