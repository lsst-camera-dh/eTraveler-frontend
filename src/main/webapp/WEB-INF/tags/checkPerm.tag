<%-- 
    Document   : checkPerm
    Created on : Jun 2, 2015, 4:59:09 PM
    Author     : focke
--%>

<%@tag description="Check permissions" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="gm" uri="http://srs.slac.stanford.edu/GroupManager"%>

<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="hasPerm" scope="AT_BEGIN"%>
<%@attribute name="groups" required="true"%>

<c:set var="inAGroup" value="false"/>
<c:forTokens var="group" items="${groups}" delims=",">
    <c:if test="${gm:isUserInGroup(pageContext, group)}">
        <c:set var="inAGroup" value="true"/>
    </c:if>
</c:forTokens>

<c:set var="hasPerm" value="${preferences.writeable
                              &&
                              (appVariables.dataSourceMode != 'Test'
                                || 
                                inAGroup
                              )}"/>
