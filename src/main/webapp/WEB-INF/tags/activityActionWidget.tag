<%-- 
    Document   : activityActionWidget
    Created on : Oct 18, 2017, 2:35:35 PM
    Author     : focke
--%>

<%@tag description="Showhistory for location, status, labels done in a step" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="activityId" required="true"%>

    <sql:query var="locQ">
select Lnew.id as newLocId, Lnew.name as newLocName, Snew.id as newSiteId, Snew.name as newSiteName,
       Lold.id as oldLocId, Lold.name as oldLocName, Sold.id as oldSiteId, Sold.name as oldSiteName
from HardwareLocationHistory HLHnew
inner join Location Lnew on Lnew.id = HLHnew.locationId
inner join Site Snew on Snew.id = Lnew.siteId
inner join HardwareLocationHistory HLHold on HLHold.id = (select max(id)
                                                          from HardwareLocationHistory
                                                          where hardwareId = HLHnew.hardwareId
                                                          and id < HLHnew.id)
inner join Location Lold on Lold.id = HLHold.locationId
inner join Site Sold on Sold.id = Lold.siteId
where HLHnew.activityId = ?<sql:param value="${activityId}"/>;
    </sql:query>

<c:forEach var="row" items="${locQ.rows}">
    <c:url var="oldSiteLink" value="displaySite.jsp">
        <c:param name="siteId" value="${row.oldSiteId}"/>
    </c:url>
    <c:url var="newSiteLink" value="displaySite.jsp">
        <c:param name="siteId" value="${row.newSiteId}"/>
    </c:url>
    <c:url var="oldLocLink" value="displayLocation.jsp">
        <c:param name="locationId" value="${row.oldLocId}"/>
    </c:url>
    <c:url var="newLocLink" value="displayLocation.jsp">
        <c:param name="locationId" value="${row.newLocId}"/>
    </c:url>
    <h3>Component was moved from <a href="${oldSiteLink}">${row.oldSiteName}</a>:<a href="${oldLocLink}">${row.oldLocName}</a> to <a href="${newSiteLink}">${row.newSiteName}</a>:<a href="${newLocLink}">${row.newLocName}</a></h3>
</c:forEach>

    
    <sql:query var="statusQ">
select HSnew.name as newName, HSold.name as oldName
from HardwareStatusHistory HSHnew
inner join HardwareStatus HSnew on HSnew.id = HSHnew.hardwareStatusId
inner join HardwareStatusHistory HSHold on HSHold.id = (select max(id) from HardwareStatusHistory where hardwareId = HSHnew.hardwareId
                                                        and id < HSHnew.id)
inner join HardwareStatus HSold on HSold.id = HSHold.hardwareStatusId
where HSHnew.activityId = ?<sql:param value="${activityId}"/>;
    </sql:query>

<c:forEach var="row" items="${statusQ.rows}">
    <h3>Component's status was changed from ${row.oldName} to ${row.newName}</h3>
</c:forEach>
    

    <sql:query var="addQ">
select L.name as labelName, LG.name as groupName
from LabelHistory LH
inner join Label L on L.id = LH.labelId
inner join LabelGroup LG on LG.id = L.labelGroupId
where LH.activityId = ?<sql:param value="${activityId}"/>
and LH.adding = 1;
    </sql:query>
    
<c:forEach var="row" items="${addQ.rows}">
    <h3>Label ${row.groupName}:${row.labelName} was added</h3>
</c:forEach>
    

    <sql:query var="remQ">
select L.name as labelName, LG.name as groupName
from LabelHistory LH
inner join Label L on L.id = LH.labelId
inner join LabelGroup LG on LG.id = L.labelGroupId
where LH.activityId = ?<sql:param value="${activityId}"/>
and LH.adding = 0;
    </sql:query>
    
<c:forEach var="row" items="${remQ.rows}">
    <h3>Label ${row.groupName}:${row.labelName} was removed</h3>
</c:forEach>
