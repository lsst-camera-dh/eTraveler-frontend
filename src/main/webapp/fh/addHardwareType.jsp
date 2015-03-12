<%-- 
    Document   : addLocation
    Created on : Oct 3, 2013, 3:19:15 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <sql:transaction>
            <sql:update>
                insert into HardwareType set
                name=?<sql:param value="${param.name}"/>,
                autoSequenceWidth=?<sql:param value="${param.width}"/>,
                description=?<sql:param value="${param.description}"/>,
                createdBy=?<sql:param value="${userName}"/>,
                creationTS=utc_timestamp();
            </sql:update>
            <sql:query var="hwtQ">
                select id as hardwareTypeId from HardwareType where id=last_insert_id();
            </sql:query>
            <c:set var="hardwareType" value="${hwtQ.rows[0]}"/>
            <sql:update>
                insert into HardwareGroup set
                name=?<sql:param value="${param.name}"/>,
                description=?<sql:param value="singleton group for htype ${param.name}"/>,
                createdBy=?<sql:param value="${userName}"/>,
                creationTS=utc_timestamp();
            </sql:update>
            <sql:query var="hwgQ">
                select id as hardwareGroupId from HardwareGroup where id=last_insert_id() ;
            </sql:query>
            <c:set var="hardwareGroup" value="${hwgQ.rows[0]}"/>
            <sql:update>
                insert into HardwareTypeGroupMapping set
                hardwareTypeId=?<sql:param value="${hardwareType.hardwareTypeId}"/>,
                hardwareGroupId=?<sql:param value="${hardwareGroup.hardwareGroupId}"/>,
                createdBy=?<sql:param value="${userName}"/>,
                creationTS=utc_timestamp();
            </sql:update>
        </sql:transaction>
        <c:redirect url="${header.referer}"/>
    </body>
</html>
