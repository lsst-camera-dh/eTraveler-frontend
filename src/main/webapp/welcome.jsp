<%@page contentType="text/html"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<html>
    <head>
        <title>Hello ${appVariables.experiment}</title>
    </head>
    <body>
        Welcome, ${empty userName?"stranger":userName}.<br>
        
        <c:url var="helpUrl" value="${initParam['helpDocumentationUrl']}"/>
        <a href="${helpUrl}"><h1>HELP</h1></a>

        <h2>Recent Activity</h2>
        <traveler:activityList/>
    </body>
</html>