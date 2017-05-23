<%-- 
    Document   : getUnsetGenericLabels
    Created on : Nov 14, 2016, 4:50 PM
    Author     : jrb
--%>

<%@tag description="get the labels that are not currently applied to an object" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="objectTypeId" required="true"%>
<%@attribute name="objectId" required="true"%>
<%@attribute name="subsysId" required="true"%>
<%@attribute name="hgResult" required="true"
             type="javax.servlet.jsp.jstl.sql.Result"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="genUnsetQ" scope="AT_BEGIN"%>

<%--
<sql:query var="genUnsetQ">
select L2.name, L2.id from Label L2
 join LabelGroup LG on L2.labelGroupId=LG.id order by L2.name;
</sql:query >
--%>

<sql:query var="genUnsetQ">
select L2.name as labelName, L2.id, LG.name as labelGroupName
from Label L2 join LabelGroup LG on L2.labelGroupId=LG.id
left join
(select L.id, L.name 
from LabelHistory LH
inner join Label L on L.id=LH.labelId
where LH.id in (select max(id)
                from LabelHistory LH2
                where LH2.objectId=?<sql:param value="${objectId}"/>
                and LH2.labelableId=?<sql:param value="${objectTypeId}" />
                group by LH2.labelId)
and LH.adding=1) L3 on L2.id=L3.id where
(LG.subsystemId = (select id from Subsystem where name = 'Default')

<c:if test="${! empty subsysId}">
  or LG.subsystemId=?<sql:param value="${subsysId}" />
</c:if>
)  and
(LG.hardwareGroupId is null
<c:forEach var="sRow" items="${hgResult.rows}">
  or LG.hardwareGroupId=?<sql:param value="${sRow.hardwareGroupId}"/>
</c:forEach>
)
and L3.id is null and LG.labelableId=?<sql:param value="${objectTypeId}" />
order by L2.name
;
   </sql:query>
