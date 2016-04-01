<%-- 
    Document   : getSetLabels
    Created on : Mar 31, 2016, 12:18:21 PM
    Author     : focke
--%>

<%@tag description="get the labels that are currently applied to a component" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="hardwareId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="labelQ" scope="AT_BEGIN"%>

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
