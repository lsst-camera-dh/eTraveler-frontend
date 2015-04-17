<%-- 
    Document   : test
    Created on : Oct 2, 2013, 3:53:56 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Test Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <br>
        role: ${preferences.role}
<c:set var="doRegister" value="${empty param.xxx ? false : param.xxx}"/>
<c:if test="${doRegister}">
        regiter:<br>
        <ta:registerFile resultId="2" mode="harnessed"/>
        <ta:registerFile resultId="9" mode="manual"/>
        <br>i mean register
        <br>
</c:if>

    </body>
</html>
