<%@page contentType="text/html"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Hardware List</title>
    </head>
    <body>
        <traveler:hardwareList hardwareTypeId="${param.hardwareTypeId}"
                               hardwareGroupId="${param.hardwareGroupId}"
                               hardwareStatusId="${param.hardwareStatusId}"
                               siteId="${param.siteId}"
                               locationId="${param.locationId}"/>
    </body>
</html>