<%-- 
    Document   : bad
    Created on : Jan 31, 2013, 10:26:48 AM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>bug test</title>
    </head>
    <body>
        <p>
            This tickles a bug somewhere unless the connection url has ?useOldAliasMetadataBehavior=true<br>
            You should see a table with 2 columns if things are working right and there are Activities and Hardwares.
        </p>
        <sql:query var="resultQ" dataSource="jdbc/rd-lsst-cam">
            select A.id as activityId, H.id as hardwareId
            from Activity A, Hardware H
            where A.hardwareId=H.id;
        </sql:query>
        <display:table name="${resultQ.rows}" class="datatable">
        </display:table>        
    </body>
</html>
