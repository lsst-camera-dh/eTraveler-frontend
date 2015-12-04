<%-- 
    Document   : defineHardwareRelationship
    Created on : Dec 1, 2015, 1:53:53 PM
    Author     : focke
--%>

<%@tag description="Define a new HardwareRelationshipType via the API" pageEncoding="UTF-8"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="lims" tagdir="/WEB-INF/tags/lims"%>

<lims:checkHardwareType var="hardwareTypeId"
    inputTypeId="${inputs.hardwareTypeId}" inputTypeName="${inputs.hardwareTypeName}"/>
<lims:checkHardwareType var="minorTypeId"
    inputTypeId="${inputs.minorTypeId}" inputTypeName="${inputs.minorTypeName}"/>

<ta:createRelationshipType slotNames="${inputs.slotNames}" minorTypeId="${minorTypeId}"
    numItems="${inputs.numItems}" name="${inputs.name}" hardwareTypeId="${hardwareTypeId}"
    description="${inputs.description}"/>

{"acknowledge": null}
