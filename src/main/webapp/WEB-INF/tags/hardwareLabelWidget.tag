<%-- 
    Document   : hardwareLabelWidget
    Created on : Mar 22, 2016, 4:30:01 PM
    Author     : focke
--%>

<%@tag description="Display various stuff about a component's labels" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="hardwareId" required="true"%>

<traveler:fullRequestString var="thisPage"/>
<traveler:checkSsPerm var="mayManage" hardwareId="${hardwareId}" roles="subsystemManager"/>

<sql:query var="labelQ">
select HS.name as statusName, HS.id as statusId, HSH.*, P.name as processName
from HardwareStatusHistory HSH
inner join HardwareStatus HS on HS.id=HSH.hardwareStatusId
    left join (Activity A
    inner join Process P on P.id=A.processId) on A.id=HSH.activityId
where HSH.id in (select max(id)
                from HardwareStatusHistory
                where hardwareId=?<sql:param value="${hardwareId}"/>
                group by hardwareStatusId)
and HS.isStatusValue=0
and HSH.adding=1
order by HSH.id desc
;
</sql:query>
    
<traveler:hardwareStatusTable result="${labelQ}"/>

<form action="operator/setHardwareStatus.jsp">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
    <input type="hidden" name="referringPage" value="${thisPage}">
    <input type="hidden" name="hardwareId" value="${hardwareId}">
    <input type="hidden" name="removeLabel" value="true">
    <select name="hardwareStatusId" required>
        <option value="" selected>Pick a label to remove</option>
        <c:forEach var="sRow" items="${labelQ.rows}">
            <option value="${sRow.statusId}"><c:out value="${sRow.statusName}"/></option>
        </c:forEach>        
    </select>
    Reason: <textarea name="reason" required="true"></textarea>
    <input type="submit" value="Remove Label"
           <c:if test="${! mayManage}">disabled</c:if>>
</form>

   <sql:query var="unsetQ">
select HS2.name, HS2.id
from HardwareStatus HS2
left join
(select HS.id, HS.name 
from HardwareStatusHistory HSH
inner join HardwareStatus HS on HS.id=HSH.hardwareStatusId
where HSH.id in (select max(id)
                from HardwareStatusHistory
                where hardwareId=?<sql:param value="${hardwareId}"/>
                group by hardwareStatusId)
and HS.isStatusValue=0
and HSH.adding=1) HS3 on HS2.id=HS3.id
where HS2.isStatusValue=0
and HS3.id is null
order by HS2.name
;
   </sql:query>

<form action="operator/setHardwareStatus.jsp">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
    <input type="hidden" name="referringPage" value="${thisPage}">
    <input type="hidden" name="hardwareId" value="${hardwareId}">
    <input type="hidden" name="removeLabel" value="false">
    <select name="hardwareStatusId" required>
        <option value="" selected>Pick a label to add</option>
        <c:forEach var="sRow" items="${unsetQ.rows}">
            <option value="${sRow.id}"><c:out value="${sRow.name}"/></option>
        </c:forEach>        
    </select>
    Reason: <textarea name="reason" required="true"></textarea>
    <input type="submit" value="Add Label"
           <c:if test="${! mayManage}">disabled</c:if>>
</form>