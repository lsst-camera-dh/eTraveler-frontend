<%-- 
    Document   : addMirror
    Created on : Oct 3, 2013, 3:19:15 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Site</title>
    </head>
    <body>
<traveler:checkFreshness formToken="${param.freshnessToken}"/>

<sql:transaction>
        <sql:update >
            insert into MirrorTask set
            name=?<sql:param value="${param.name}"/>,
            sourceDirectory=?<sql:param value="${param.sourceDirectory}"/>,
            dcSite=?<sql:param value="${param.dcSite}"/>,
            createdBy=?<sql:param value="${userName}"/>,
            creationTS=UTC_TIMESTAMP();
        </sql:update>
        <sql:query var="siteQ">
            select last_insert_id() as id;
        </sql:query>
</sql:transaction>
        <c:redirect url="${param.referringPage}"/>
    </body>
</html>
