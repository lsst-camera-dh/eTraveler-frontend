<%-- 
    Document   : signSignature
    Created on : Apr 12, 2016, 3:18:54 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
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
    <ta:signSignature signatureId="${param.signatureId}"/>
</sql:transaction>
<c:redirect url="${param.referringPage}"/>
    </body>
</html>
