<%@page contentType="text/html"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="filter" uri="http://srs.slac.stanford.edu/filter"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

    <sql:query var="statesQ">
select name from HardwareStatus order by name;
    </sql:query>

<!DOCTYPE html>
<html>
    <head>
        <title>Hardware List</title>
    </head>
    <body>
        <c:choose>
            <c:when test="${! empty param.status}">
                <c:set var="theStatus" value="${param.status}"/>
            </c:when>
            <c:otherwise>
                <c:set var="theStatus" value="any"/>
            </c:otherwise>
        </c:choose>
        
        <filter:filterTable>
            <filter:filterInput var="name" title="Type (substring search)"/>
            <filter:filterSelection title="Status" var="status" defaultValue='${theStatus}'>
                <filter:filterOption value="any">Any</filter:filterOption>
                <c:forEach var="statusName" items="${statesQ.rows}">
                    <filter:filterOption value="${statusName.name}"><c:out value="${statusName.name}"/></filter:filterOption>
                </c:forEach>
            </filter:filterSelection>
        </filter:filterTable>
        <traveler:hardwareList hardwareTypeId="${param.hardwareTypeId}"
                               hardwareGroupId="${param.hardwareGroupId}"
                               hardwareStatusName="${status}"
                               siteId="${param.siteId}"
                               locationId="${param.locationId}"
                               name="${name}"/>
    </body>
</html>