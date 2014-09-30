<%-- 
    Document   : stepList
    Created on : Jul 24, 2014, 11:42:55 AM
    Author     : focke
--%>

<%@tag description="Make a list of the steps in an activity, including NCRs" pageEncoding="UTF-8"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="theList" scope="AT_BEGIN"%>

<%
    java.util.List theList = new java.util.LinkedList();
    jspContext.setAttribute("theList", theList);
%>

<traveler:insertTraveler activityId="${activityId}" theList="${theList}"/>
