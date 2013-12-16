<%-- 
    Document   : startActivity
    Created on : Aug 1, 2013, 12:11:08 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <sql:update >
            update Activity set
            begin=now()
            where id=?<sql:param value="${param.activityId}"/>
        </sql:update>
            
        <c:redirect url="displayActivity.jsp">
            <c:param name="activityId" value="${param.topActivityId}"/>                
        </c:redirect>
            
    </body>
</html>
