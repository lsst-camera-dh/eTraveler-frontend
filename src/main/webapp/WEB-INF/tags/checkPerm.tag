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
<%@attribute name="group" required="true"%>

<c:set var="hasPerm" value="${gm:isUserInGroup(pageContext, group) && preferences.writeable}"/>
