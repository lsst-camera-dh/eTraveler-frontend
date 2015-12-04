<%-- 
    Document   : createHardwareType
    Created on : Nov 13, 2015, 1:47:20 PM
    Author     : focke
--%>

<%@tag description="Add a new HardwareType" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="name" required="true"%>
<%@attribute name="width" required="true"%>
<%@attribute name="isBatched" required="true"%>
<%@attribute name="description" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="hardwareTypeId" scope="AT_BEGIN"%>

    <sql:update>
insert into HardwareType set
name=?<sql:param value="${name}"/>,
autoSequenceWidth=?<sql:param value="${width}"/>,
isBatched=?<sql:param value="${isBatched}"/>,
description=?<sql:param value="${description}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=utc_timestamp();
    </sql:update>
    <sql:query var="hwtQ">
select id as hardwareTypeId from HardwareType where id=last_insert_id();
    </sql:query>
<c:set var="hardwareType" value="${hwtQ.rows[0]}"/>

    <sql:update>
insert into HardwareGroup set
name=?<sql:param value="${name}"/>,
description=?<sql:param value="singleton group for htype ${name}"/>,
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

<c:set var="hardwareTypeId" value="${hardwareType.hardwareTypeId}"/>
