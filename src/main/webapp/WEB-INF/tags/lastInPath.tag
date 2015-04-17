<%-- 
    Document   : lastInPath
    Created on : Apr 5, 2013, 8:48:18 AM
    Author     : focke
--%>

<%@tag description="Get the last component of a period-delimited path" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@attribute name="processPath" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="processId" scope="AT_BEGIN"%>

<c:set var="processArr" value="${fn:split(param.processPath, '.')}"/>
<c:set var="processId" value="${processArr[fn:length(processArr)-1]}"/>
