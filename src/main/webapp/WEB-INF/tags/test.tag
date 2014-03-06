<%-- 
    Document   : test
    Created on : Mar 4, 2014, 11:26:11 AM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="message"%>

<%-- any content can be specified here e.g.: --%>
<h2>Start Test</h2>
<c:set var="fnord" value="eleventy" scope="request"/>
[${pageContext.request.getHeader("Referer")}]<br>
[${returnTo}]<br>
<h2>End Test</h2>