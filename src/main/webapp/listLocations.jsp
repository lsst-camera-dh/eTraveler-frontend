<%@page contentType="text/html"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Location List</title>
    </head>
    <body>
        <traveler:locationList siteId="${param.siteId}"/>
    </body>
</html>