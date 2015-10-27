<%-- 
    Document   : hasHarnessedSteps
    Created on : Sep 21, 2015, 4:11:30 PM
    Author     : focke
--%>

<%@tag description="Figure out whether a process or any of its children are harnessed" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="processId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="hasHarnessedSteps" scope="AT_BEGIN"%>

<traveler:expandProcess var="stepList" processId="${processId}"/>

<c:set var="hasHarnessedSteps" value="false"/>
<c:forEach var="row" items="${stepList}">
    <c:if test="${row.isHarnessed != 0}">
        <c:set var="hasHarnessedSteps" value="true"/>
    </c:if>
</c:forEach>
