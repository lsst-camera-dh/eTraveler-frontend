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
            <c:forEach var="row" items="${idAuthQ.rows}">
                <preferences:value value="${row.name}"/>
            </c:forEach>
        </preferences:preference>
    </preferences:preferences>
            
    </body>
</html>

