<%-- 
    Document   : defineHardwareRelationship
    Created on : Dec 1, 2015, 1:53:53 PM
    Author     : focke
--%>

<%@tag description="Define a new HardwareRelationshipType via the API" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<ta:createRelationshipType slotNames="${inputs.slotNames}" minorTypeId="${inputs.minorTypeId}"
    numItems="${inputs.numItems}" name="${inputs.name}" hardwareTypeId="${inputs.hardwareTypeId}"
    description="${inputs.description}"/>
