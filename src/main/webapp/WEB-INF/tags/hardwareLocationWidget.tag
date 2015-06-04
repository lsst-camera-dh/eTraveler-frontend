<%-- 
    Document   : hardwareLocationWidget
    Created on : Sep 24, 2013, 11:46:45 AM
    Author     : focke
--%>

<%@tag description="Display various stuff about a component's location" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="hardwareId" required="true"%>

<traveler:checkPerm var="mayOperate" groups="EtravelerOperator,EtravelerSupervisor"/>

<sql:query  var="locationHistoryQ">
    select HLH.*,
    L.id as locationId, L.name as locationName, 
    S.id as siteId, S.name as siteName
    from
    HardwareLocationHistory HLH
    inner join Location L on L.id=HLH.locationId
    inner join Site S on S.id=L.siteId
    where
    HLH.hardwareId=?<sql:param value="${hardwareId}"/>
    order by HLH.creationTS desc
</sql:query>
    
<display:table name="${locationHistoryQ.rows}" class="datatable" sort="list"
               pagesize="${fn:length(locationHistoryQ.rows) > preferences.pageLength ? preferences.pageLength : 0}">
    <display:column property="siteName" title="Site"
                    href="displaySite.jsp" paramId="siteId" paramProperty="siteId"/>
    <display:column property="locationName" title="Location"
                    href="displayLocation.jsp" paramId="locationId" paramProperty="locationId"/>
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
    where hardwareId=?<sql:param value="${hardwareId}"/>
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
        and S.name=?<sql:param value="${preferences.siteName}"/>
        order by S.name, L.name;
    </sql:query>

    <form action="operator/setHardwareLocation.jsp" method="GET">
        <input type="hidden" name="hardwareId" value="${hardwareId}">
        <select name="newLocationId" required>
            <option value="" selected>Pick a new location</option>
            <c:forEach var="lRow" items="${locationsQ.rows}">
                <option value="${lRow.id}">${lRow.siteName} ${lRow.locationName}</option>
            </c:forEach>
        </select>
        <input type="submit" value="Move it!"
            <c:if test="${! mayOperate}">disabled</c:if>>
    </form>
</c:if>