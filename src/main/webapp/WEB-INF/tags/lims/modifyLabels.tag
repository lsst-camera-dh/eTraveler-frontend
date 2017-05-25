<%-- 
    Document   : modifyLabels
    Created on : Mar 25, 2016, 4:45:14 PM
    Author     : focke
--%>

<%@tag description="set/unset label via API" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="lims" tagdir="/WEB-INF/tags/lims"%>

<lims:checkHardwareType var="htId" inputTypeName="${inputs.hardwareTypeName}" inputTypeId="${inputs.hardwareTypeId}"/>

<traveler:findComponent var="hardwareId" serial="${inputs.experimentSN}" typeName="${inputs.hardwareTypeName}"/>

<c:set var="reason" value="${empty inputs.reason ? 'Set via API' : inputs.reason}"/>

    <sql:query var="labelQ">
select L.id as labelId, LA.id as objectTypeId
from Label L
inner join LabelGroup LG on LG.id = L.labelGroupId
inner join Labelable LA on LA.id = LG.labelableId
where L.name = ?<sql:param value="${inputs.labelName}"/>
and LG.name = ?<sql:param value="${inputs.labelGroupName}"/>
and LA.name = 'hardware'
;
    </sql:query>
<c:set var="label" value="${labelQ.rows[0]}"/>

<ta:modifyLabels labelId="${label.labelId}" removeLabel="${! inputs.adding}"
                 objectId="${hardwareId}" objectTypeId="${label.objectTypeId}"
                 activityId="${inputs.activityId}" reason="${reason}"/>

{ "acknowledge": null }