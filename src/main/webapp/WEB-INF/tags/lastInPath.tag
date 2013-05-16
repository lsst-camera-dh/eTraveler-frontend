<%-- 
    Document   : lastInPath
    Created on : Apr 5, 2013, 8:48:18 AM
    Author     : focke
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@tag description="Sets request-scoped processId to the last component of a period-delimited path" pageEncoding="US-ASCII"%>

<%@attribute name="processPath" required="true"%>

<c:set var="processArr" value="${fn:split(param.processPath, '.')}"/>
<c:set var="processId" value="${processArr[fn:length(processArr)-1]}" scope="request"/>
