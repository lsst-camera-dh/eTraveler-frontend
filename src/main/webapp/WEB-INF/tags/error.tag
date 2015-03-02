<%-- 
    Document   : error
    Created on : Mar 2, 2015, 3:41:46 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="message"%>

<c:url var="errorPage" value="error.jsp">
    <c:param name="message" value="${param.message}"/>
</c:url>
<c:redirect url="${errorPage}"/>
