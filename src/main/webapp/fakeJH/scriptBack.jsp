<%-- 
    Document   : registerBack
    Created on : Nov 11, 2013, 3:46:14 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        ${param}
	<form method=post action="http://localhost:8084/eTraveler/Test/Results/nextJob">
            <input type=hidden name="jsonObject" value='{
                   "operator": "${param.operator}",
                       "containerid":${param.containerid}
                       }'>
	  <input type=submit value="do it">
	</form>
    </body>
</html>
