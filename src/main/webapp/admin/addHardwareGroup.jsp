<%-- 
    Document   : addHardwareGroup
    Created on : Mar 13, 2015, 1:02:15 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Hardware Group</title>
    </head>
    <body>
        <traveler:checkFreshness formToken="${param.freshnessToken}"/>
        
        <sql:transaction>
            <sql:update>
                insert into HardwareGroup set
                name=?<sql:param value="${param.name}"/>,
                description=?<sql:param value="${param.description}"/>,
                createdBy=?<sql:param value="${userName}"/>,
                creationTS=UTC_TIMESTAMP();
            </sql:update>
            <sql:query var="hgQ">
                select last_insert_id() as hardwareGroupId;
            </sql:query>
        </sql:transaction>
        <c:redirect url="/displayHardwareGroup.jsp" context="/eTraveler">
            <c:param name="hardwareGroupId" value="${hgQ.rows[0].hardwareGroupId}"/>
        </c:redirect>
    </body>
</html>
