<%-- 
    Document   : createTraveler
    Created on : Jul 2, 2014, 11:24:10 AM
    Author     : focke
--%>

<%@tag description="Start a process traveler" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="hardwareId" required="true"%>
<%@attribute name="processId" required="true"%>
<%@attribute name="inNCR"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="activityId" scope="AT_BEGIN"%>

<c:if test="${empty inNCR}">
    <c:set var="inNCR" value="false"/>
</c:if>

<sql:update>
    insert into Activity set
    hardwareId=?<sql:param value="${hardwareId}"/>,
    processId=?<sql:param value="${processId}"/>,
    inNCR=?<sql:param value="${inNCR}"/>,
    createdBy=?<sql:param value="${userName}"/>,
    creationTS=UTC_TIMESTAMP();
</sql:update>
<sql:query var="activityQ">
    select * from Activity where id=LAST_INSERT_ID();
</sql:query>

<c:set var="activity" value="${activityQ.rows[0]}"/>
<c:set var="activityId" value="${activity.id}"/>

<sql:query var="hardwareQ">
    select H.*, HS.name
    from Hardware H
    inner join HardwareStatusHistory HSH on HSH.hardwareId=H.id and HSH.id=(select max(id) from HardwareStatusHistory where hardwareId=H.id)
    inner join HardwareStatus HS on HS.id=HSH.hardwareStatusId
    where H.id=?<sql:param value="${hardwareId}"/>;
</sql:query>
<c:if test="${hardwareQ.rows[0].name == 'NEW'}">
    <sql:query var="statQ">
        select id from HardwareStatus where name='IN_PROGRESS';
    </sql:query>
    <ta:setHardwareStatus hardwareId="${hardwareId}" hardwareStatusId="${statQ.rows[0].id}"/>
</c:if>
