<%-- 
    Document   : eclForm
    Created on : Apr 1, 2014, 3:03:22 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="author" required="true"%>
<%@attribute name="hardwareTypeId" required="true"%>
<%@attribute name="hardwareId"%>
<%@attribute name="processId"%>
<%@attribute name="activityId"%>

<%-- any content can be specified here e.g.: --%>
<h2>Post a comment to eLog</h2>
<form method="GET" action="eclPost.jsp">
    <input type="hidden" name="author" value="${author}">
    <input type="hidden" name="hardwareTypeId" value="${hardwareTypeId}">
    <input type="hidden" name="hardwareId" value="${hardwareId}">
    <input type="hidden" name="processId" value="${processId}">
    <input type="hidden" name="activityId" value="${activityId}">
    <input type="textarea" name="text">
    <input type="SUBMIT" value="Post">
</form>