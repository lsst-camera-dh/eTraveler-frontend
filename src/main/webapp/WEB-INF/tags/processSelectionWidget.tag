<%-- 
    Document   : processSelectionWidget
    Created on : Jan 15, 2014, 4:21:02 PM
    Author     : focke
--%>

<%@tag description="Handle selection steps" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="processId" %>

    <sql:query var="choicesQ">
select 
Pp.substeps,
PE.child, PE.id as edgeId, PE.step, (case Pp.substeps
    when 'SELECTION' then PE.cond
    when 'HARDWARE_SELECTION' then (case 
        when PE.branchHardwareTypeId is null then 'Default'
        else (select name from HardwareType where id = PE.branchHardwareTypeId)
        end)
    end) as cond,
Pc.name
from ProcessEdge PE
inner join Process Pc on Pc.id=PE.child
inner join Process Pp on Pp.id = PE.parent
where Pp.id=?<sql:param value="${processId}"/>
order by abs(PE.step);
    </sql:query>

<c:set var="conditionTitle" value="${choicesQ.rows[0].subSteps == 'HARDWARE_SELECTION' ? 'Hardware Type' : 'Condition'}"/>

<h2>Selections</h2>
<display:table name="${choicesQ.rows}" id="childRow" class="datatable">
    <display:column property="step" sortable="true" headerClass="sortable"/>
    <display:column property="cond" title="${conditionTitle}" sortable="true" headerClass="sortable"/>
</display:table>
