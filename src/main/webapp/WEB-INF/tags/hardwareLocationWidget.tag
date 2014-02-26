<%-- 
    Document   : hardwareLocationWidget
    Created on : Sep 24, 2013, 11:46:45 AM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="hardwareId" required="true"%>

<sql:query  var="locationHistoryQ">
    select L.name as locationName, S.name as siteName, HLH.* 
    from
    HardwareLocationHistory HLH
    inner join Location L on L.id=HLH.locationId
    inner join Site S on S.id=L.siteId
    where
    HLH.hardwareId=?<sql:param value="${hardwareId}"/>
    order by HLH.creationTS desc
    limit 10
</sql:query>
    
<display:table name="${locationHistoryQ.rows}" class="datatable">
    <display:column property="siteName" title="Site"/>
    <display:column property="locationName" title="Location"/>
    <display:column property="creationTS" title="When"/>
    <display:column property="createdBy" title="Who"/>
</display:table>
    
<sql:query var="parentsQ" >
    select * from HardwareRelationship 
    where componentId=?<sql:param value="${hardwareId}"/>
    and end is null;
</sql:query>

<sql:query var="locQ">
    select locationId 
    from HardwareLocationHistory 
    where hardwareId=?<sql:param value="${param.hardwareId}"/>
    order by creationTS desc limit 1;
</sql:query>
<c:if test="${! empty locQ.rows}">
    <c:set var="currentLoc" value="${locQ.rows[0].locationId}"/>
</c:if>

<c:if test="${empty parentsQ.rows}">
    <sql:query var="locationsQ" >
        select L.id, L.name as locationName, S.name as siteName
        from
        Location L
        inner join Site S on S.id=L.siteId
        where 1
        <c:if test="${! empty currentLoc}">
            and L.id!=?<sql:param value="${currentLoc}"/>
        </c:if>
        <c:if test="${! empty sessionScope.siteId}">
            and S.id=?<sql:param value="${sessionScope.siteId}"/>
        </c:if>
    </sql:query>

    <form action="setHardwareLocation.jsp" method="GET">
        <input type="hidden" name="hardwareId" value="${hardwareId}"/>
        <select name="newLocationId" required>
            <option value="" selected>Pick a new location</option>
            <c:forEach var="lRow" items="${locationsQ.rows}">
                <option value="${lRow.id}">
                    <c:if test="${empty sessionScope.siteId}">${lRow.siteName} </c:if>
                    ${lRow.locationName}
                </option>
            </c:forEach>
        </select>
        <input type="submit" value="Move it!"/>
    </form>
</c:if>