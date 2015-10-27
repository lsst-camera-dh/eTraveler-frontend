<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="preferences" uri="http://srs.slac.stanford.edu/preferences"%>
<%@page import="java.util.*"%>
<%@page isELIgnored="false"%>
<%@page contentType="text/html"%>

<html>
    <head>
        <title>eTraveler Preferences</title>
    </head>
    
    <body>
        
        <sql:query var="siteQ" >
            select id, name from Site;
        </sql:query>
            
        <sql:query var="idAuthQ" >
            select id, name from HardwareIdentifierAuthority;
        </sql:query>
            
        <preferences:preferences name="preferences">

            <preferences:preference name="writeable" title="<b>Write:</b> ">
                <preferences:value value="false"/>
                <preferences:value value="true"/>
            </preferences:preference>
        <tr>
            <td>Downgrade your permissions. If this is false, you won't be able to do anything, just look.</td>
            <td>Current Value: <c:out value="${preferences.writeable}"/></td>
        </tr>

        <preferences:preference name="siteName" title="<b>Site:</b> ">
                <c:forEach var="row" items="${siteQ.rows}">
                    <preferences:value value="${row.name}"/>
                </c:forEach>
            </preferences:preference>
        <tr>
            <td>This will be preselected on some forms.<br>
            You can only move components to locations at your site.</td>
            <td>Current Value: <c:out value="${preferences.siteName}"/></td>
        </tr>


            <preferences:preference name="idAuthName" title="<b>Identifier Authority:</b> ">
                <preferences:value value="null"/>
                <c:forEach var="row" items="${idAuthQ.rows}">
                    <preferences:value value="${row.name}"/>
                </c:forEach>
            </preferences:preference>
        <tr>
            <td>This will be preselected on some forms.<br>
            If not null, The selected identifier will appear in component and activity lists.</td>
            <td>Current Value: <c:out value="${preferences.idAuthName}"/></td>
        </tr>


            <preferences:preference name="pageLength" size="3" title="<b>Page Length:</b> " />
        <tr>
            <td>This is the number of rows to show in paginated tables.<br>
            0 is unlimited.</td>
            <td>Current Value: <c:out value="${preferences.pageLength}"/></td>
        </tr>

            <preferences:preference name="componentHeight" size="2" title="<b>Parent list limit:</b> " />
        <tr>
            <td>When listing what assembly the current component is part of, go up the tree this many lavels.</td>
            <td>Current Value: <c:out value="${preferences.componentHeight}"/></td>
        </tr>

            <preferences:preference name="componentDepth" size="2" title="<b>Component list depth:</b> " />
        <tr>
            <td>When listing the subassemblies or components of an assembly, go down the tree this many lavels.</td>
            <td>Current Value: <c:out value="${preferences.componentDepth}"/></td>
        </tr>

            <preferences:preference name="showFilteredColumns" title="<b>Show Filtered Columns:</b> ">
                <preferences:value value="true"/>
                <preferences:value value="false"/>
            </preferences:preference>
        <tr>
            <td>Normally, list columns which would always have the same value due to filtering options are not shown.<br>
                Like, the list of process travelers for a component doesn't really need a column for the component serial number,<br>
                and the list of components at a site doesn't need a column for the site name.<br>
            Setting this to true will show them.</td>
            <td>Current Value: <c:out value="${preferences.showFilteredColumns}"/></td>
        </tr>

        </preferences:preferences>
            
    </body>
</html>

