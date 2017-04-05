<%-- 
    Document   : addLabelGroup
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
        <title>Add a new generic label group</title>
    </head>
    <body>
        <traveler:checkFreshness formToken="${param.freshnessToken}"/>
        <c:set var="theGroup" value="EtravelerAllAdmin"/>
        <traveler:checkPerm var="mayAdmin" groups="${theGroup}"/>
        <c:if test="${! mayAdmin}">
            <traveler:error message="You must be a member of group ${theGroup} to add new label types."/>
        </c:if>
        <sql:transaction>
            <sql:update>
insert into LabelGroup set
name = ?<sql:param value="${param.name}"/>,
<c:if test="${! empty param.subsysId}">
    subsystemId = ?<sql:param value="${param.subsysId}"/>,
</c:if>
<c:if test="${! empty param.hGroupId}">
    hardwareGroupId = ?<sql:param value="${param.hGroupId}"/>,
</c:if>
labelableId = ?<sql:param value="${param.labelableId}"/>,
createdBy = ?<sql:param value="${userName}"/>,
creationTS = UTC_TIMESTAMP();
            </sql:update>
        </sql:transaction>
        <c:redirect url="${param.referringPage}"/>
    </body>
</html>
