<%-- 
    Document   : jhWidget
    Created on : Mar 17, 2014, 12:03:23 PM
    Author     : focke
--%>

<%@tag description="Display job harness-related stuff for an Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>

<traveler:jhHistoryWidget activityId="${activityId}"/>

<traveler:jhResultWidget activityId="${activityId}"/>
