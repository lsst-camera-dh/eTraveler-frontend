<%-- 
    Document   : createHardware
    Created on : Oct 15, 2015, 5:17:00 PM
    Author     : focke
--%>

<%@tag description="Register new Hardware" pageEncoding="UTF-8"%>
<%@tag import = "java.util.Date,java.text.SimpleDateFormat,java.text.ParseException"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="hardwareTypeId" required="true"%>
<%@attribute name="lsstId"%>
<%@attribute name="quantity"%>
<%@attribute name="manufacturer"%>
<%@attribute name="manufacturerId"%>
<%@attribute name="model"%>
<%@attribute name="manufactureDateStr"%>
<%@attribute name="locationId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="hardwareId" scope="AT_BEGIN"%>

<c:if test="${! empty lsstId}">
    <sql:query var="dupQ">
select id from Hardware 
where lsstId=?<sql:param value="${lsstId}"/>
and hardwareTypeId=?<sql:param value="${hardwareTypeId}"/>
;
    </sql:query>
    <c:if test="${! empty dupQ.rows}">
        <traveler:error message="Duplicate experiment serial number ${lsstId}"/>
    </c:if>
</c:if>

<c:if test="${! empty manufactureDateStr}">
<%
String dateStr = jspContext.getAttribute("manufactureDateStr").toString();  
SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
Date result = formater.parse(dateStr);
jspContext.setAttribute("manufactureDate", result);
%>
</c:if>

    <sql:query var="typeQ" >
select * from HardwareType
where id=?<sql:param value="${hardwareTypeId}"/>;
    </sql:query>
<c:set var="hType" value="${typeQ.rows[0]}"/>

<c:if test="${hType.autoSequenceWidth != 0}">
    <sql:update>
        update HardwareType set autoSequence=LAST_INSERT_ID(autoSequence+1)
        where id=?<sql:param value="${hardwareTypeId}"/>;
    </sql:update>
</c:if>
    <sql:update>
insert into Hardware set
<c:choose>
    <c:when test="${hType.autoSequenceWidth == 0}">
lsstId=?<sql:param value="${lsstId}"/>,
    </c:when>
    <c:otherwise>
lsstId=concat(
    ?<sql:param value="${hType.name}"/>,
    '-',
    <c:if test="${hType.isBatched != 0}">'B',</c:if>
    LPAD(LAST_INSERT_ID(), ?<sql:param value="${hType.autoSequenceWidth}"/>, '0')
),
    </c:otherwise>
</c:choose>
hardwareTypeId=?<sql:param value="${hardwareTypeId}"/>,
manufacturer=?<sql:param value="${manufacturer}"/>,
manufacturerId=?<sql:param value="${manufacturerId}"/>,
model=?<sql:param value="${model}"/>,
manufactureDate=?<sql:dateParam value="${manufactureDate}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=UTC_TIMESTAMP();
    </sql:update>
    <sql:query var="hardwareQ">
select id from Hardware where id=LAST_INSERT_ID();
    </sql:query>
<c:set var="hardware" value="${hardwareQ.rows[0]}"/>
<c:set var="hardwareId" value="${hardware.id}"/>
<ta:setHardwareStatus hardwareId="${hardwareId}" hardwareStatusName="NEW" reason="New Item"/>
<ta:setHardwareLocation hardwareId="${hardwareId}" newLocationId="${locationId}"
                        reason="New component registration"/>
<c:if test="${hType.isBatched != 0}">
    <ta:adjustBatchInventory hardwareId="${hardwareId}" adjustment="${quantity}" reason="New batch"/>
</c:if>
