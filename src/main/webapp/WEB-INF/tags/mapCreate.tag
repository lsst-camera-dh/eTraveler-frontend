<%-- 
    Document   : mapCreate
    Created on : May 13, 2015, 4:20:49 PM
    Author     : focke
--%>

<%@tag description="create a map" pageEncoding="UTF-8"%>

<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="theMap" variable-class="java.util.Map"%>

<%
    java.util.Map<String,Object> theMap = new java.util.HashMap();
    jspContext.setAttribute("theMap", theMap);
%>
