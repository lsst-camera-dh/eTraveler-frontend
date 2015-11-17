<%-- 
    Document   : limsOneStep
    Created on : Oct 15, 2015, 4:53:48 PM
    Author     : focke
--%>

<%@tag description="Run a one-step input traveler from scripting API" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%--
<%@attribute name="hardwareId" required="true"%>
<%@attribute name="hardwareGroup" required="true"%>
<%@attribute name="name" required="true"%>
<%@attribute name="version"%>
<%@attribute name="inputs"%>
--%>

<traveler:findProcess var="processId" 
                      name="${inputs.name}" version="${inputs.version}"
                      hardwareGroup="${inputs.hardwareGroup}"/>

<traveler:countSteps var="nSteps" processId="${processId}"/>
<c:if test="${nSteps != 1}">
    <traveler:error message="Not a single-step traveler."/>
</c:if>

<ta:createTraveler var="activityId"
                   processId="${processId}" hardwareId="${inputs.hardwareId}"/>
