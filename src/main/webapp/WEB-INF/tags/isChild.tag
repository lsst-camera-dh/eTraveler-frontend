<%-- 
    Document   : isChild
    Created on : Jul 31, 2014, 12:06:21 PM
    Author     : focke
--%>

<%@tag description="Determine if a step is the immediate child of another.
       This is not general - it only works if they are known to be parts of the same traveler!" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="parentEdgePath" required="true"%>
<%@attribute name="childEdgePath" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="isChild" scope="AT_BEGIN"%>

<c:set var="childComponents" value="${fn:split(childEdgePath, '.')}"/>
<traveler:dotOrNot var="testHead" prefix="${parentEdgePath}"/>
<c:set var="testPath" value="${testHead}${childComponents[fn:length(childComponents)-1]}"/>
<c:set var="isChild" value="${testPath == childEdgePath}"/>
