<%-- 
    Document   : getUnsetLabels
    Created on : Mar 31, 2016, 12:23:16 PM
    Author     : focke
--%>

<%@tag description="get the labels that are not currently applied to a component" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="hardwareId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="unsetQ" scope="AT_BEGIN"%>

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
