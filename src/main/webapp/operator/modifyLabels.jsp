<%-- 
    Document   : modifyLabels.jsp
    Created on : Nov. 30 2016
    Author     : jrb
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Modify Labels</title>
    </head>
    <body>
        <traveler:checkFreshness formToken="${param.freshnessToken}"/>        
        
        <c:if test="${empty param.objectId}">
            <traveler:error message="You must specifiy which object to label."/>
        </c:if>
        
        <c:if test="${empty param.labelId}">
            <traveler:error message="You must specify label."/>
        <c:if test="${empty param.objectTypeId}">
            <traveler:error message="You must specify type of object to label."/>	
        </c:if>
        
        
        <sql:transaction>
            <ta:modifyLabels labelId="${param.labelId}"
	    objectId="${param.objectId}" objectTypeId="${param.objectTypeId}"
	    reason="${param.reason}" removeLabel="${param.removeLabel}"/>
        </sql:transaction>
        <c:redirect url="${param.referringPage}"/>
</body>
</html>
