<%-- 
    Document   : encode
    Created on : Mar 3, 2016, 12:17:22 PM
    Author     : focke
--%>

<%@tag description="turn a Map into JSON" pageEncoding="UTF-8"%>
<%@tag import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@attribute name="input" required="true" type="java.lang.Object"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="output" scope="AT_BEGIN"%>

<c:set var="output" value='<%= new ObjectMapper().writeValueAsString(jspContext.getAttribute("input")) %>'/>
