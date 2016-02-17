<%-- 
    Document   : addJhInstall
    Created on : Sep 17, 2015, 5:15:15 PM
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
        <title>JSP Page</title>
    </head>
    <body>
        <traveler:checkFreshness formToken="${param.freshnessToken}"/>

        <sql:transaction>
            <sql:update>
insert into JobHarness set
name=?<sql:param value="${param.name}"/>,
description=?<sql:param value="${param.description}"/>,
jhVirtualEnv=?<sql:param value="${param.jhVirtualEnv}"/>,
jhOutputRoot=?<sql:param value="${param.jhOutputRoot}"/>,
jhStageRoot=?<sql:param value="${param.jhStageRoot}"/>,
jhCfg=?<sql:param value="${param.jhCfg}"/>,
siteId=?<sql:param value="${param.siteId}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=utc_timestamp();
            </sql:update>
        </sql:transaction>
        <c:redirect url="${param.referringPage}"/>
    </body>
</html>
