<%-- 
    Document   : createRelationshipType
    Created on : Dec 1, 2015, 1:58:18 PM
    Author     : focke
--%>

<%@tag description="Add a new HardwareRelationshipType" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="slotNames" required="true"%>
<%@attribute name="minorTypeId" required="true"%>
<%@attribute name="numItems" required="true"%>
<%@attribute name="name" required="true"%>
<%@attribute name="hardwareTypeId" required="true"%>
<%@attribute name="description" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="mrtId" scope="AT_BEGIN"%>

<sql:query var="slotQ">
    select id from MultiRelationshipType where name=?<sql:param value="${name}"/> and hardwareTypeId=?<sql:param value="${hardwareTypeId}"/>;
</sql:query>
<c:if test="${! empty slotQ.rows}">
    <traveler:error message="A relationship type with name ${name} and parent type ${hardwareTypeId} already exists."/>
</c:if>

<c:set var="slotList" value="${fn:split(slotNames, ',')}"/>
<c:set var="nSlots" value="${fn:length(slotList)}"/>
<c:choose>
    <c:when test="${nSlots == 1}">
        <c:set var="singleBatch" value="1"/>
        <sql:query var="batchedQ">
select isBatched from HardwareType where id=?<sql:param value="${minorTypeId}"/>;
        </sql:query>
        <c:if test="${batchedQ.rows[0].isBatched == 0 && numItems != 1}">
            <traveler:error message="Can't specify multiple non-batched items in a single slot."/>
        </c:if>
    </c:when>
    <c:otherwise>
        <c:choose>
            <c:when test="${nSlots == numItems}">
                <c:set var="singleBatch" value="0"/>
            </c:when>
            <c:otherwise>
                <traveler:error message="# items does not match slot names."/>
            </c:otherwise>
        </c:choose>
    </c:otherwise>
</c:choose>
        
            
    <sql:update >
insert into MultiRelationshipType set
name=?<sql:param value="${name}"/>,
hardwareTypeId=?<sql:param value="${hardwareTypeId}"/>,
minorTypeId=?<sql:param value="${minorTypeId}"/>,
description=?<sql:param value="${description}"/>,
singleBatch=?<sql:param value="${singleBatch}"/>,
nMinorItems=?<sql:param value="${numItems}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=UTC_TIMESTAMP();
    </sql:update>
    <sql:query var="mrtIdQ">
select last_insert_id() as mrtId;
    </sql:query>
<c:set var="mrtId" value="${mrtIdQ.rows[0].mrtId}"/>

<%-- now add slots --%>
<c:forEach var="slotName" items="${slotList}">
    <c:set var="slotName" value="${fn:trim(slotName)}"/>
    <sql:update>
insert into MultiRelationshipSlotType set
multiRelationshipTypeId=?<sql:param value="${mrtId}"/>,
slotName=?<sql:param value="${slotName}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=UTC_TIMESTAMP();
    </sql:update>
</c:forEach>
