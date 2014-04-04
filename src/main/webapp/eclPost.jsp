<%-- 
    Document   : eclPost
    Created on : Apr 1, 2014, 1:15:34 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="/WEB-INF/eclTagLibrary.tld" prefix="ecl"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h2>Psych, this doesn't actually post yet.</h2>
    <ecl:eclPost 
        text="${param.text}" 
        author="${param.author}" 
        hardwareTypeId="${param.hardwareTypeId}" 
        hardwareId="${param.hardwareId}" 
        processId="${param.processId}" 
        activityId="${param.activityId}"
        />
    </body>
</html>
