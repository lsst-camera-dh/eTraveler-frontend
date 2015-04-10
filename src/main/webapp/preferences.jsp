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
        <tr>
            <td>Downgrade your permissions</td>
            <td>Current Value: <c:out value="${preferences.role}"/></td>
        </tr>

        <preferences:preference name="siteName" title="Site: ">
                <c:forEach var="row" items="${siteQ.rows}">
                    <preferences:value value="${row.name}"/>
                </c:forEach>
            </preferences:preference>
        <tr>
            <td>This will be preselected on some forms.<br>
            You can only move components to locations at your site.</td>
            <td>Current Value: <c:out value="${preferences.siteName}"/></td>
        </tr>


            <preferences:preference name="idAuthName" title="Identifier Authority: ">
                <preferences:value value="null"/>
                <c:forEach var="row" items="${idAuthQ.rows}">
                    <preferences:value value="${row.name}"/>
                </c:forEach>
            </preferences:preference>
        <tr>
            <td>This will be preselected on some forms.<br>
            If not null, The selected identifier will appear in component list.</td>
            <td>Current Value: <c:out value="${preferences.idAuthName}"/></td>
        </tr>


            <preferences:preference name="pageLength" size="3" title="Page Length: " />
        <tr>
            <td>This is the number of rows to show in paginated tables.</td>
            <td>Current Value: <c:out value="${preferences.pageLength}"/></td>
        </tr>

            <preferences:preference name="componentHeight" size="2" title="Parent list limit: " />
        <tr>
            <td>When listing what assembly the current component is part of, go up the tree this many lavels.</td>
            <td>Current Value: <c:out value="${preferences.componentHeight}"/></td>
        </tr>

            <preferences:preference name="componentDepth" size="2" title="Component list depth: " />
        <tr>
            <td>When listing the subassemblies or components of an assembly, this sets how many levels into the tree it goes.</td>
            <td>Current Value: <c:out value="${preferences.componentDepth}"/></td>
        </tr>

            <preferences:preference name="showFilteredColumns" title="Show Filtered Columns: ">
                <preferences:value value="true"/>
                <preferences:value value="false"/>
            </preferences:preference>
        <tr>
            <td>Normally, list columns which would always have the same value due to filtering options are not shown.<br>
            Setting this to true will show them.</td>
            <td>Current Value: <c:out value="${preferences.showFilteredColumns}"/></td>
        </tr>

        </preferences:preferences>
            
    </body>
</html>

