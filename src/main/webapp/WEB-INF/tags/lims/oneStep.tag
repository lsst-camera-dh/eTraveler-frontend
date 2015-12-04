<%-- 
    Document   : limsOneStep
    Created on : Oct 15, 2015, 4:53:48 PM
    Author     : focke
--%>

<%@tag description="Run a one-step input traveler from scripting API" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<traveler:findComponent var="hardwareId" serial="${inputs.experimentSN}"
                        inputId="${inputs.hardwareId}" groupName="${inputs.hardwareGroup}"
                        typeName="${inputs.htype}"/>

<traveler:findProcess var="processId" 
                      name="${inputs.travelerName}" version="${inputs.travelerVersion}"
                      hardwareGroup="${inputs.hardwareGroup}"/>

<traveler:countSteps var="nSteps" processId="${processId}"/>
<c:if test="${nSteps != 1}">
    <traveler:error message="Not a single-step traveler."/>
</c:if>

<ta:createTraveler var="activityId"
                   processId="${processId}" hardwareId="${hardwareId}"/>

<ta:startActivity activityId="${activityId}"/>

<c:forEach var="input" items="${inputs.operatorInputs}">
    <traveler:inputResultWrapper activityId="${activityId}" 
                                 inputName="${input.key}" value="${input.value}"/>
</c:forEach>

<ta:closeoutActivity activityId="${activityId}"/>

{"acknowledge": null}
