<%-- 
    Document   : registerBack
    Created on : Nov 11, 2013, 3:46:14 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        ${param}
	<form method=post action="http://localhost:8084/eTraveler/Test/Results/requestID">
            <input type=hidden name="jsonObject" value='{"jobid":<c:choose>
                       <c:when test="${! empty param.jobid}">${param.jobid}</c:when>
                       <c:otherwise>null</c:otherwise></c:choose>,
                       "stamp":${param.stamp},
                       "unit_type":"${param.unit_type}",
                       "unit_id":"${param.unit_id}",
                       "job":"${param.job}",
                       "version":"${param.version}",
                       "operator":"${param.operator}"}'>
	  <input type=submit value="do it">
	</form>
    </body>
</html>
