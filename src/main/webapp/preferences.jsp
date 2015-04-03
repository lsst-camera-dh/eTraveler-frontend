<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="preferences" uri="http://srs.slac.stanford.edu/preferences" %>
<%@ page import="java.util.*" %>
<%@ page isELIgnored="false" %>
<%@ page contentType="text/html" %>

<html>
    <head>
        <title>eTraveler Preferences</title>
    </head>
    
    <body>
        
        <sql:query var="roleQ">
            select id, name from PermissionGroup
        </sql:query>
            
        <sql:query var="siteQ" >
            select id, name from Site;
        </sql:query>
            
        <sql:query var="idAuthQ" >
            select id, name from HardwareIdentifierAuthority;
        </sql:query>
            
        <preferences:preferences name="preferences">

            <preferences:preference name="role" title="Role: ">
                <c:forEach var="row" items="${roleQ.rows}">
                    <preferences:value value="${row.name}"/>
                </c:forEach>
            </preferences:preference>

            <preferences:preference name="siteName" title="Site: ">
                <c:forEach var="row" items="${siteQ.rows}">
                    <preferences:value value="${row.name}"/>
                </c:forEach>
            </preferences:preference>

            <preferences:preference name="idAuthName" title="Identifier Authority: ">
                <preferences:value value="null"/>
                <c:forEach var="row" items="${idAuthQ.rows}">
                    <preferences:value value="${row.name}"/>
                </c:forEach>
            </preferences:preference>

            <preferences:preference name="pageLength" size="3" title="Page Length: " />

            <preferences:preference name="componentHeight" size="2" title="Parent list limit: " />

            <preferences:preference name="componentDepth" size="2" title="Component list depth: " />

            <preferences:preference name="showFilteredColumns" title="Show Filtered Columns: ">
                <preferences:value value="true"/>
                <preferences:value value="false"/>
            </preferences:preference>

        </preferences:preferences>
            
    </body>
</html>

