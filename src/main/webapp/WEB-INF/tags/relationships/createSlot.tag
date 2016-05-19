<%-- 
    Document   : createSlot
    Created on : May 17, 2016, 2:50:33 PM
    Author     : focke
--%>

<%@tag description="Add a slot" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="slotTypeId" required="true"%>
<%@attribute name="hardwareId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="slotId" scope="AT_BEGIN"%>

    <sql:update>
insert into MultiRelationshipSlot set
multirelationshipTypeId = ?<sql:param value="${slotTypeId}"/>,
hardwareId = ?<sql:param value="${hardwareId}"/>,
createdBy = ?<sql:param value="${userName}"/>,
creationTS = utc_timestap();
    </sql:update>
    <sql:query var="slotQ">
select last_insert_id() as slotId;
    </sql:query>
<c:set var="slotId" value="${slotQ.rows[0].slotId}"/>
