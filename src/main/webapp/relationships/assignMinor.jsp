<%-- 
    Document   : assignMinor
    Created on : May 24, 2016, 2:25:59 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="relationships" tagdir="/WEB-INF/tags/relationships"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Assign component ${param.minorId} to slot ${param.slotId}</title>
    </head>
    <body>
<traveler:checkFreshness formToken="${param.freshnessToken}"/>

<sql:transaction>
    <relationships:updateRelationship slotId="${param.slotId}" 
                                      minorId="${param.minorId}" 
                                      activityId="${param.activityId}" 
                                      action="assign"/>
</sql:transaction>
<c:redirect url="${param.referringPage}"/>
    </body>
</html>
