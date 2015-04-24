<%-- 
    Document   : ncrExitActivity
    Created on : Oct 2, 2014, 3:02:17 PM
    Author     : focke
--%>

<%@tag description="put an Activity in ncrExit state" pageEncoding="UTF-8"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="activityId" required="true"%>

<ta:setActivityStatus activityId="${activityId}" status="ncrExit"/>
