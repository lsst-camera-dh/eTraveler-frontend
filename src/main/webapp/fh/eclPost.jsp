<%-- 
    Document   : eclPost
    Created on : Apr 1, 2014, 1:15:34 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib uri="/tlds/eclTagLibrary.tld" prefix="ecl"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Post to eLog</title>
    </head>
    <body>
    <traveler:checkFreshness formToken="${param.freshnessToken}"/>
    
    <c:set var="text" value="${param.text}<br>${param.displayLink}"/>
        
    <ecl:eclPost 
        text="${text}" 
        author="${param.author}" 
        dataSourceMode="dataSourceMode${appVariables.dataSourceMode}"
        hardwareTypeId="${param.hardwareTypeId}" 
        hardwareGroupId="${param.hardwareGroupId}" 
        hardwareId="${param.hardwareId}" 
        processId="${param.processId}" 
        activityId="${param.activityId}"
        category="${param.category}"
        version="${param.version}"
        url="${appVariables.etravelerELogUrl}"
        />
    </body>
    
    <c:redirect url="${param.referringPage}"/>
</html>
