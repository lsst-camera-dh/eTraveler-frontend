<%-- 
    Document   : new
    Created on : Jun 1, 2015, 11:32:38 AM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="gm" uri="http://srs.slac.stanford.edu/GroupManager"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <c:choose>
        <c:when test="${gm:isUserInGroup(pageContext,'EtravelerAdmin')}">
            yup<br>
        </c:when>
        <c:otherwise>
            nah<br>
        </c:otherwise>
        </c:choose>
    </body>
</html>
