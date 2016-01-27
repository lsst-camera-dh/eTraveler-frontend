<%-- 
    Document   : checkPerm
    Created on : Jun 2, 2015, 4:59:09 PM
    Author     : focke
--%>

<%@tag description="Check permissions against a list of named groups" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="gm" uri="http://srs.slac.stanford.edu/GroupManager"%>

<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="hasPerm" scope="AT_BEGIN"%>
<%@attribute name="groups" required="true"%>

<%-- Is the dataSourceMode protected? --%>
<c:set var="inAMode" value="false"/>
<c:forTokens var="mode" items="${appVariables.etravelerProtectedModes}" delims=",">
    <c:if test="${appVariables.dataSourceMode == mode}">
        <c:set var="inAMode" value="true"/>
    </c:if>    
</c:forTokens>

<c:choose>
    <c:when test="${! preferences.writeable}">
        <c:set var="hasPerm" value="false"/>
    </c:when>
    <c:when test="${! inAMode}">
        <c:set var="hasPerm" value="true"/>
    </c:when>
    <c:otherwise>
        <c:if test="${empty requestScope.userGroupList}">
            <c:set var="userGroupList" value="${gm:getGroupsForUser(pageContext, 'all')}" scope="request"/>
        </c:if>
        
        <%-- Is the user in an allowed group? --%>
        <c:set var="hasPerm" value="false"/>
        <c:forEach var="userGroup" items="${userGroupList}">
            <c:if test="${! hasPerm}">
                <c:set var="userGroup" value="${fn:trim(userGroup)}"/>
                <c:forTokens var="neededGroup" items="${groups}" delims=",">
                    <c:if test="${! hasPerm}">
                        <c:if test="${userGroup == neededGroup}">
                            <c:set var="hasPerm" value="true"/>
                        </c:if>
                    </c:if>
                </c:forTokens>
            </c:if>
        </c:forEach>
    </c:otherwise>
</c:choose>

