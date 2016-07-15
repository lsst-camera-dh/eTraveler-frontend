<%-- 
    Document   : createSubBatch
    Created on : Jul 15, 2016, 4:17:40 PM
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
        <title>Crate child batch</title>
    </head>
    <body>
<traveler:checkFreshness formToken="${param.freshnessToken}"/>

<sql:transaction>
    <batch:createSubBatch var="childId" parentId="${param.parentId}" numItems="${param.numItems}" reason="${param.reason}"/>
</sql:transaction>

<c:redirect url="/displayHardware.jsp" context="/eTraveler">
    <c:param name="hardwareId" value="${childId}"/>
</c:redirect>
    </body>
</html>
