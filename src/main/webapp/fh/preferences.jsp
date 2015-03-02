<%@taglib prefix="logging" uri="/WEB-INF/tags/logging.tld" %>
<%@taglib prefix="gm" uri="http://srs.slac.stanford.edu/GroupManager" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="preferences" uri="http://srs.slac.stanford.edu/preferences" %>
<%@ page import="java.util.*" %>
<%@ page isELIgnored="false" %>
<%@ page contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
    <head>
        <title>Preferences</title>
    </head>
    
    <body>
        
        <c:set var="preferencesName" value="${ operationMode == 'shift' ? 'shifterpreferences' : 'preferences'}" />

        <c:if test="${operationMode == 'user' || gm:isUserInGroup(pageContext,'ShifterAdmin')}">
            <preferences:preferences name="${preferencesName}" title="Apply Column Selection">
                <preferences:preference name="tableColumns" title="Selected Table Columns: " multiple="true">
                    <c:forEach items="${logging:tableColumnsAllowedValues()}" var="item">
                        <preferences:value value="${item}"/>
                    </c:forEach>
                </preferences:preference>
            </preferences:preferences>            
            <preferences:preferences name="${preferencesName}" title="Apply Column Widths">
                <c:set var="preferencesObj" value="${ operationMode == 'shift' ? shifterpreferences : preferences}" />                
                <c:set var="selectedColumns" value="${preferencesObj.tableColumns}"/>
                <c:forEach items="${logging:tableColumnsAllowedValues()}" var="item">
                    <c:if test="${logging:isColumnSelected(selectedColumns, item)}">
                        <preferences:preference name="${logging:propertyName(item)}" title="${item}: " size="5"/>
                    </c:if>
                </c:forEach>   
            </preferences:preferences>            
            <preferences:manageHistory name="${preferencesName}" property="configuration"/>
        </c:if>
        <preferences:manageHistory name="preferences" property="eventSelection"/>
        <preferences:manageHistory name="preferences" property="progSelection"/>
        <preferences:manageHistory name="preferences" property="gidSelection"/>
        <preferences:manageHistory name="preferences" property="tgtSelection"/>
        <preferences:manageHistory name="preferences" property="usrSelection"/>
        <preferences:manageHistory name="preferences" property="hostSelection"/>
        
    </body>
</html>

