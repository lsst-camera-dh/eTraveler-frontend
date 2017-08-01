<%-- 
    Document   : addGenricLabelType
    Created on : Mar 22, 2016, 6:37:07 PM
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
        <title>Add a new generic label type</title>
    </head>
    <body>
        <traveler:checkSpaces var="theName" input="${param.name}" fieldName="Name"/>
        <traveler:checkFreshness formToken="${param.freshnessToken}"/>
        <c:set var="theGroup" value="EtravelerAllAdmin"/>
        <traveler:checkPerm var="mayAdmin" groups="${theGroup}"/>
        <c:if test="${! mayAdmin}">
            <traveler:error message="You must be a member of group ${theGroup} to add new label types."/>
        </c:if>
        <sql:transaction>
            <sql:update>
insert into Label set
name = ?<sql:param value="${theName}"/>,
description = ?<sql:param value="${param.description}"/>,
labelGroupId = ?<sql:param value="${param.groupId}"/>,
createdBy = ?<sql:param value="${userName}"/>,
creationTS = UTC_TIMESTAMP();
            </sql:update>
        </sql:transaction>
        <c:redirect url="${param.referringPage}"/>
    </body>
</html>
