<%-- 
    Document   : createRelationship
    Created on : Aug 13, 2015, 4:43:22 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>create relationship</title>
    </head>
    <body>
<traveler:checkFreshness formToken="${param.freshnessToken}"/>

<sql:transaction>
    <ta:createRelationship hardwareId="${param.hardwareId}" minorId="${param.minorId}" 
                           slotTypeId="${param.slotTypeId}" activityId="${param.activityId}"/>
</sql:transaction>        
<c:redirect url="${param.referringPage}"/>
    </body>
</html>
