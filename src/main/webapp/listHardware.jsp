<%@page contentType="text/html"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Hardware List</title>
    </head>
    <body>
        <traveler:hardwareList hardwareTypeId="${param.hardwareTypeId}"/>
    </body>
</html>