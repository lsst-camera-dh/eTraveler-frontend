<%-- 
    Document   : limsDefineHardwareType
    Created on : Nov 12, 2015, 11:21:11 AM
    Author     : focke
--%>

<%@tag description="Add a new HardwareType from scripting API" pageEncoding="UTF-8"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<ta:createHardwareType var="hardwareTypeId" name="${inputs.name}" subsystemId="${inputs.subsystemId}"
                       width="${inputs.sequenceWidth}" isBatched="${inputs.batchedFlag}"
                       description="${inputs.description}"/>

{"id": ${hardwareTypeId}, "acknowledge": null}
