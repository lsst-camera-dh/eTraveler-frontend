<%-- 
    Document   : adjustBatchInventory
    Created on : Jul 14, 2015, 4:16:23 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="batch" tagdir="/WEB-INF/tags/batches"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Batch Inventory Adjustment</title>
    </head>
    <body>
<traveler:checkFreshness formToken="${param.freshnessToken}"/>

<sql:transaction>
    <batch:adjustInventory hardwareId="${param.hardwareId}" 
                           sourceBatchId="${param.sourceBatchId}" 
                           adjustment="${param.adjustment}" 
                           reason="${param.reason}"/>
</sql:transaction>        
<c:redirect url="${param.referringPage}"/>
    </body>
</html>
