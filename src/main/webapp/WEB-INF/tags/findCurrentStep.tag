<%-- 
    Document   : findCurrentStep
    Created on : Jul 29, 2014, 2:39:30 PM
    Author     : focke
--%>

<%@tag description="Figure out the current step of a traveler instance" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@attribute name="stepList" required="true" type="java.util.List"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="currentStepLink"%>

<c:forEach var="step" items="${stepList}">
    
</c:forEach>
