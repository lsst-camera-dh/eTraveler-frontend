<%-- 
    Document   : mapAdd
    Created on : May 13, 2015, 4:21:07 PM
    Author     : focke
--%>

<%@tag description="add an item to a map" pageEncoding="UTF-8"%>

<%@attribute name="theMap" required="true" type="java.util.Map"%>
<%@attribute name="key" required="true" type="java.lang.String"%>
<%@attribute name="value" required="true"%>

<%
    java.util.Map theMap = (java.util.Map) jspContext.getAttribute("theMap");
    theMap.put(jspContext.getAttribute("key"), jspContext.getAttribute("value"));
%>
