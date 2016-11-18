<%-- 
    Document   : getUnsetGenericLabels
    Created on : Nov 14, 2016, 4:50 PM
    Author     : jrb
--%>

<%@tag description="get the labels that are not currently applied to an object" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="objectTypeId" required="true"%>
<%@attribute name="objectId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="unsetQ" scope="AT_BEGIN"%>

<sql:query var="genUnsetQ">
select L2.name, L2.id
from Label L2
left join
(select L.id, L.name 
from LabelHistory LH
inner join Label L on L.id=LH.labelId
where LH.id in (select max(id)
                from LabelHistory
                where objectId=?<sql:param value="${objectId}"/>
                      <%-- and objectTypeId=?<sql:param value="${objectTypeId}" /> --%>
                group by labelId)
and LH.adding=1) L3 on L2.id=L3.id
<%--
<c:if test="${! subsysId=null}">
  and LG.subsystemId=?<sql:param value="${subsysId}" />
  or LG.subsystemId="" />
</c:if>
--%>
and L3.id is null
order by L2.name
;
   </sql:query>
