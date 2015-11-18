<%-- 
    Document   : inputResult
    Created on : Dec 18, 2013, 4:05:25 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Input Result</title>
    </head>
    <body>
<sql:transaction>
    <ta:inputResult activityId="${param.activityId}" inputPatternId="${param.inputPatternId}" 
                    isName="${param.isName}" value="${param.value}"/>
</sql:transaction>
        <c:redirect url="${param.referringPage}"/>
    </body>
</html>
