<%-- 
    Document   : limsScript
    Created on : Aug 8, 2014, 10:52:34 AM
    Author     : focke
--%>

<%@tag description="Supply the next command for scripted sequences." pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<traveler:stepList var="stepList" mode="activity" theId="${inputs.containerid}"/>
<traveler:findCurrentStep stepList="${stepList}" scriptMode="true"
    varStepLink="childActivityId" varStepEPath="edgePath"/>
<traveler:autoProcessPrereq var="gotAllPrereqs" activityId="${childActivityId}"/>
<%-- choke if not gotAllPrereqs --%>
<traveler:startActivity activityId="${childActivityId}"/>

<%-- respond with well-formed JSON --%>
