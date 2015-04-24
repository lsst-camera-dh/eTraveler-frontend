<%-- 
    Document   : startActivity
    Created on : Aug 8, 2014, 1:16:56 PM
    Author     : focke
--%>

<%@tag description="Start an existing Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="activityId" required="true"%>

<ta:setActivityStatus activityId="${activityId}" status="inProgress"/>
