<%-- 
    Document   : showSlots
    Created on : May 24, 2016, 1:22:16 PM
    Author     : focke
--%>

<%@tag description="disaplay and do relationship stuff for an Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="relationships" tagdir="/WEB-INF/tags/relationships"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="ready" scope="AT_BEGIN"%>

<relationships:addSlots activityId="${activityId}"/>
<relationships:checkSlots var="isSane" activityId="${activityId}"/>
<relationships:displaySlotActions var="allAssigned" activityId="${activityId}" enabled="${isSane}"/>

<c:set var="ready" value="${isSane && allAssigned}"/>
