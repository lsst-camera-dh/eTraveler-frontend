<%-- 
    Document   : defineRelationshipType
    Created on : Dec 1, 2015, 1:53:53 PM
    Author     : focke
--%>

<%@tag description="Define a new MultiRelationshipType via the API" pageEncoding="UTF-8"%>
<%@taglib prefix="lims" tagdir="/WEB-INF/tags/lims"%>
<%@taglib prefix="relationships" tagdir="/WEB-INF/tags/relationships"%>

<lims:checkHardwareType var="hardwareTypeId"
    inputTypeId="${inputs.hardwareTypeId}" inputTypeName="${inputs.hardwareTypeName}"/>
<lims:checkHardwareType var="minorTypeId"
    inputTypeId="${inputs.minorTypeId}" inputTypeName="${inputs.minorTypeName}"/>

<relationships:createRelationshipType slotNames="${inputs.slotNames}" minorTypeId="${minorTypeId}"
    numItems="${inputs.numItems}" name="${inputs.name}" hardwareTypeId="${hardwareTypeId}"
    description="${inputs.description}" var="mrtId"/>

{"id": ${mrtId}, "acknowledge": null}
