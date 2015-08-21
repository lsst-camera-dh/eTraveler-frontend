<%-- 
    Document   : updateHardwareRelationship
    Created on : Jul 28, 2015, 5:29:19 PM
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
        <title>JSP Page</title>
    </head>
    <body>
<sql:transaction>
    <ta:updateRelationship slotId="${param.slotId}" action="${param.action}"/>
</sql:transaction>        
<c:redirect url="${param.referringPage}"/>
    </body>
</html>
