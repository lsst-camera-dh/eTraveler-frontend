<%-- 
    Document   : displayMirror
    Created on : Apr 2, 2015, 9:00:19 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<sql:query var="mirrorQ">
    select * from MirrorTask where id=?<sql:param value="${param.mirrorId}"/>;
</sql:query>
<c:set var="mirror" value="${mirrorQ.rows[0]}"/>
    
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Mirror Task <c:out value="${mirror.name}"/></title>
    </head>
    <body>
        <h3>Mirror Info</h3>
        Name: <c:out value="${mirror.name}"/><br>
        Creator: <c:out value="${mirror.createdBy}"/><br>
        Date: <c:out value="${mirror.creationTS}"/><br>
        
        <h3>Job Harness Installs</h3>
        <traveler:newJhForm mirrorId="${param.mirrorId}"/>
        <traveler:jhList mirrorId="${param.mirrorId}"/>
    </body>
</html>
