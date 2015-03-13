<%-- 
    Document   : processPane
    Created on : May 21, 2013, 12:42:51 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Process <c:out value="${param.processId}"/></title>
        <link href="http://srs.slac.stanford.edu/Commons/css/srsCommons.jsp?experimantName=${appVariables.experiment}"rel="stylesheet" type="text/css" />
    </head>
    <body>
        <sql:query var="processQ" >
            select concat(P.name, ' v', P.version) as processName, P.hardwareTypeId
            from Process P
            where P.id=?<sql:param value="${param.processId}"/>;
        </sql:query>
        <c:set var="process" value="${processQ.rows[0]}"/>
          
        <h2><c:out value="${process.processName}"/></h2>
        <traveler:processWidget processId="${param.processId}"/>
        
        <c:if test="${! empty param.parentActivityId}">
            <%-- This is only set if this process is the current step and is not instantiated
            which never happens if activities are autocreated --%>
            <form METHOD=GET ACTION="fh/createActivity.jsp" target="_top">
                <input type="hidden" name="parentActivityId" value="${param.parentActivityId}">       
                <input type="hidden" name="processEdgeId" value="${param.processEdgeId}">       
                <input type="hidden" name="inNCR" value="${param.inNCR}">       
                <input type="hidden" name="hardwareId" value="${param.hardwareId}">       
                <input type="hidden" name="processId" value="${param.processId}">       
                <input type="hidden" name="topActivityId" value="${param.topActivityId}">       
                <INPUT TYPE=SUBMIT value="Start Prep">
            </form>
        </c:if>
        <traveler:eclWidget
            author="${userName}"
            hardwareTypeId="${process.hardwareTypeId}"
            processId="${param.processId}"
            />
    </body>
</html>
