<%-- 
    Document   : addHardwareRelationshipType
    Created on : Oct 3, 2013, 3:19:15 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add HardwareRelationshipType</title>
    </head>
    <body>
        <c:set var="slotNames" value="${fn:split(param.slotNames, ',')}"/>
        <c:set var="nSlots" value="${fn:length(slotNames)}"/>
        <c:choose>
            <c:when test="${nSlots == 1}">
                <c:set var="singleBatch" value="1"/>
                <sql:query var="batchedQ">
select isBatched from HardwareType where id=?<sql:param value="${param.minorTypeId}"/>;
                </sql:query>
                <c:if test="${batchedQ.rows[0].isBatched == 0 && param.nItems != 1}">
                    <traveler:error message="Can't specify multiple non-batched items in a single slot."/>
                </c:if>
            </c:when>
            <c:otherwise>
                <c:choose>
                    <c:when test="${nSlots == param.nItems}">
                        <c:set var="singleBatch" value="0"/>
                    </c:when>
                    <c:otherwise>
                        <traveler:error message="# items does not match slot names."/>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>
        
        <sql:transaction>
            
            <sql:update >
insert into MultiRelationshipType set
name=?<sql:param value="${param.name}"/>,
hardwareTypeId=?<sql:param value="${param.hardwareTypeId}"/>,
minorTypeId=?<sql:param value="${param.minorTypeId}"/>,
description=?<sql:param value="${param.description}"/>,
singleBatch=?<sql:param value="${singleBatch}"/>,
nMinorItems=?<sql:param value="${param.nItems}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=UTC_TIMESTAMP();
            </sql:update>
            <sql:query var="mrtIdQ">
select last_insert_id() as mrtId;
            </sql:query>
            <c:set var="mrtId" value="${mrtIdQ.rows[0].mrtId}"/>
            
<%-- now add slots --%>
            <c:forEach var="slotName" items="${slotNames}">
                <sql:update>
insert into MultiRelationshipSlotType set
multiRelationshipTypeId=?<sql:param value="${mrtId}"/>,
slotName=?<sql:param value="${slotName}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=UTC_TIMESTAMP();
                </sql:update>
            </c:forEach>
            
        </sql:transaction>
        <c:redirect url="${param.referringPage}"/>
    </body>
</html>
