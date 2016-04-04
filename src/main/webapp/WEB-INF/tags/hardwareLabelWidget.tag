<%-- 
    Document   : hardwareLabelWidget
    Created on : Mar 22, 2016, 4:30:01 PM
    Author     : focke
--%>

<%@tag description="Display various stuff about a component's labels" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="hardwareId" required="true"%>

<sql:query var="labelQ">
select HS.name as statusName, HSH.*, P.name as processName
from HardwareStatusHistory HSH
inner join HardwareStatus HS on HS.id=HSH.hardwareStatusId
    left join (Activity A
    inner join Process P on P.id=A.processId) on A.id=HSH.activityId
where HSH.id in (select max(id)
                from HardwareStatusHistory
                where hardwareId=2
                group by hardwareStatusId)
and HS.isStatusValue=0
and HSH.adding=1
order by HSH.id desc
</sql:query>
    
<traveler:hardwareStatusTable result="${labelQ}"/>

