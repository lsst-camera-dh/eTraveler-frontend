<%-- 
    Document   : test
    Created on : Oct 2, 2013, 3:53:56 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="gm" uri="http://srs.slac.stanford.edu/GroupManager"%>
<%@taglib prefix="preferences" uri="http://srs.slac.stanford.edu/preferences"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib uri="/tlds/eclTagLibrary.tld" prefix="ecl"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Test Page</title>
    </head>
    <body>
        <traveler:fullRequestString var="here"/>
        ${here}
        <br> <c:set var="bork" value="<%=response.getContentType()%>"/>
        =${bork}=
        ${pageContext.response.contentType}<br>
        <c:forEach var="group" items="${gm:getGroupsForUser(pageContext, 'all')}">
            <br>-${group}
        </c:forEach>
        <traveler:test/>
        <br>
        <traveler:hasHarnessedSteps var="foo" processId="121"/>
        [${foo}]
        <br>

---${gm:isUserInGroup(pageContext, "AintNoSuchGroup")}---
        <h1>Hello World!</h1>
        <br>
        [${appVariables.dataSourceMode}]${preferences.writeable}<br>
        <c:choose>
        <c:when test="${gm:isUserInGroup(pageContext,'EtravelerAdmin')}">
            yup<br>
        </c:when>
        <c:otherwise>
            nah<br>
        </c:otherwise>
        </c:choose>
    </body>
</html>
