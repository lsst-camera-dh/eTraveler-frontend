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
                <c:set var="theState" value="${param.status}"/>
            </c:when>
            <c:otherwise>
                <c:set var="theState" value="any"/>
            </c:otherwise>
        </c:choose>
        
        <filter:filterTable>
            <filter:filterSelection title="State" var="state" defaultValue='${theState}'>
                <filter:filterOption value="any">Any</filter:filterOption>
                <c:forEach var="stateName" items="${statesQ.rows}">
                    <filter:filterOption value="${stateName.name}"><c:out value="${stateName.name}"/></filter:filterOption>
                </c:forEach>
            </filter:filterSelection>
        </filter:filterTable>
        <traveler:hardwareList hardwareTypeId="${param.hardwareTypeId}"
                               hardwareGroupId="${param.hardwareGroupId}"
                               hardwareStatusName="${state}"
                               siteId="${param.siteId}"
                               locationId="${param.locationId}"/>
    </body>
</html>