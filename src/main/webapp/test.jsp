<%-- 
    Document   : test
    Created on : Oct 2, 2013, 3:53:56 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="gm" uri="http://srs.slac.stanford.edu/GroupManager"%>
<%@taglib prefix="preferences" uri="http://srs.slac.stanford.edu/preferences"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="ecl" uri="/tlds/eclTagLibrary.tld"%>
<%@taglib prefix="lims" tagdir="/WEB-INF/tags/lims"%>
<%@taglib prefix="relationships" tagdir="/WEB-INF/tags/relationships"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Test Page</title>
    </head>
    <body>
        <relationships:showSlotHistory slotId="12"/>
        <traveler:test/>
        ${fileItems}<br>
${fn:length(paramValues['value'])} ${param.nInputs}<br>
    <c:forEach var="pattern" begin="0" end="${param.nInputs - 1}" step="1">
                    <c:set var="inputName" value="inputPatternId${pattern}"/>
                    <c:set var="valueName" value="value${pattern}"/>
        
<%--        <ta:inputResult inputPatternId="${paramValues['inputPatternId'][pattern]}" 
                        value="${paramValues['value'][pattern]}" 
                        activityId="${param.activityId}"/>--%>
<c:if test="${! empty param[valueName]}">
${inputName} ${param[inputName]} ${valueName} ${param[valueName]}<br>
${fileItems[valueName].name}<br>
</c:if>
    </c:forEach>
    </body>
</html>
