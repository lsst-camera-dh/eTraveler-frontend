<%-- 
    Document   : checkUser
    Created on : Jun 29, 2017, 11:55:16 AM
    Author     : focke
--%>

<%@tag description="check whether operator is the magic one" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="isMagic" scope="AT_BEGIN"%>

<c:set var="isMagic" value="${inputs.operator == appVariables.eTravelerAPIUser ? true : false}"/>
