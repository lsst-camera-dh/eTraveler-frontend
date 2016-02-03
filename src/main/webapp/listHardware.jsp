<%@page contentType="text/html"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="filter" uri="http://srs.slac.stanford.edu/filter"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

    <sql:query var="statesQ">
select name from HardwareStatus order by name;
    </sql:query>

    <sql:query var="sitesQ">
select name from Site order by name;
    </sql:query>

    <sql:query var="subsysQ">
select name from Subsystem order by name;
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
            <filter:filterInput var="serial" title="Serial # (substring search)"/>
            <filter:filterSelection title="Site" var="site" defaultValue='${preferences.siteName}'>
                <filter:filterOption value="any">Any</filter:filterOption>
                <filter:filterOption value="${preferences.siteName}">User Pref</filter:filterOption>
                <c:forEach var="siteName" items="${sitesQ.rows}">
                    <filter:filterOption value="${siteName.name}"><c:out value="${siteName.name}"/></filter:filterOption>
                </c:forEach>
            </filter:filterSelection>
            <filter:filterSelection title="Subsystem" var="subsystem" defaultValue="${preferences.subsystem}">
                <filter:filterOption value="Any">Any</filter:filterOption>
                <filter:filterOption value="${preferences.subsystem}">User Pref</filter:filterOption>
                <c:forEach var="subsystem" items="${subsysQ.rows}">
                    <filter:filterOption value="${subsystem.name}"><c:out value="${subsystem.name}"/></filter:filterOption>
                </c:forEach>                
            </filter:filterSelection>
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
                               siteName="${site}"
                               locationId="${param.locationId}"
                               name="${name}"
                               serial="${serial}"
                               subsystemId="${param.subsystemId}"
                               subsystemName="${subsystem}"/>
    </body>
</html>