<%-- 
    Document   : checkId
    Created on : Mar 11, 2014, 4:12:21 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="table" required="true"%>
<%@attribute name="id" required="true"%>

<sql:query var="idQ">
    select id from ${table} where id=?<sql:param value="${id}"/>
</sql:query>
    
<c:if test="${empty idQ.rows}">
    <c:redirect url="welcome.jsp"/>
</c:if>