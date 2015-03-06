<%@page contentType="text/html"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<html>
    <head>
        <title>Hello ${appVariables.experiment}</title>
    </head>
    <body>
        Welcome, ${empty userName?"stranger":userName}.<br>
        

        <h2>Recent Activity</h2>
        <traveler:activityList/>
    </body>
</html>