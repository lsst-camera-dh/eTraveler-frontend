<%-- 
    Document   : setHardwareStatus
    Created on : Mar 25, 2016, 4:45:14 PM
    Author     : focke
--%>

<%@tag description="change hardware status (or set/unset label) via API" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="lims" tagdir="/WEB-INF/tags/lims"%>

<lims:checkHardwareType var="htId" inputTypeName="${inputs.hardwareTypeName}" inputTypeId="${inputs.hardwareTypeId}"/>

<traveler:findComponent var="hardwareId" serial="${inputs.experimentSN}" typeName="${inputs.hardwareTypeName}"/>

<c:set var="reason" value="${empty inputs.reason ? 'Set via API' : inputs.reason}"/>

<c:set var="removeLabel" value="${! inputs.adding}"/>

<ta:setHardwareStatus activityId="${inputs.activityId}" hardwareId="${hardwareId}" 
                      hardwareStatusName="${inputs.hardwareStatusName}" reason="${reason}" 
                      removeLabel="${removeLabel}"/>

{ "acknowledge": null }