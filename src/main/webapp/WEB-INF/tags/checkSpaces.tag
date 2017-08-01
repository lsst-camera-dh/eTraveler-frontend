<%-- 
    Document   : checkSpaces
    Created on : Aug 1, 2017, 11:43:27 AM
    Author     : focke
--%>

<%@tag description="make sure input strings don't contain spaces" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="input" required="true"%>
<%@attribute name="fieldName"%>
<%@variable name-from-attribute="var" alias="output" scope="AT_BEGIN"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>

<c:set var="output" value="${fn:trim(input)}"/>
<c:if test="${fn:contains(output, ' ')}">
    <traveler:error message="Field '${fieldName}' cannot contain spaces"/>
</c:if>