<%-- 
    Document   : adjustBatchInventory
    Created on : Jul 14, 2015, 4:16:23 PM
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
        <title>Batch Inventory Adjustment</title>
    </head>
    <body>
<sql:transaction>
    <ta:adjustBatchInventory hardwareId="${param.hardwareId}" adjustment="${param.adjustment * param.sign}" reason="${param.reason}"/>
</sql:transaction>        
<c:redirect url="${header.referer}"/>
    </body>
</html>
