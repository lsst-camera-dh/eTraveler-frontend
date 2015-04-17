<%-- 
    Document   : eclPost
    Created on : Apr 1, 2014, 1:15:34 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib uri="/tlds/eclTagLibrary.tld" prefix="ecl"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Post to eLog</title>
    </head>
    <body>
    
    <c:set var="text" value="${param.text}<br>${param.displayLink}"/>
        
    <ecl:eclPost 
        text="${text}" 
        author="${param.author}" 
        hardwareTypeId="${param.hardwareTypeId}" 
        hardwareId="${param.hardwareId}" 
        processId="${param.processId}" 
        activityId="${param.activityId}"
        version="${param.version}"
        />
    </body>
    
    <c:redirect url="${header.referer}"/>
</html>
