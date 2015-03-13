<%-- 
    Document   : test
    Created on : Mar 4, 2014, 11:26:11 AM
    Author     : focke
--%>

<%@tag description="test varios stuff - dev tool only" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@attribute name="message"%>

<h2>Start Test</h2>
<c:set var="fnord" value="eleventy" scope="request"/>
[${pageContext.request.getHeader("Referer")}]<br>
[${pageContext.getRequest().getServerName()}]<br>
[${pageContext.request.scheme}]<br>
[${pageContext.request.serverName}]<br>
[${pageContext.request.serverPort}]<br>
[${pageContext.request.contextPath}]<br>
[[${appVariables.dataSourceMode}]]<br>
<c:set var="req" value="pageContext.request"/>
[${request.contextPath}]<br>
<h2>End Test</h2>