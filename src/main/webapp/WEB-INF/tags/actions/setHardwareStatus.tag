<%-- 
    Document   : setHardwareStatus
    Created on : Jun 27, 2013, 2:44:09 PM
    Author     : focke
--%>

<%@tag description="Change the status of a component" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="hardwareId" required="true"%>
<%@attribute name="hardwareStatusId"%>
<%@attribute name="hardwareStatusName"%>
<%@attribute name="activityId"%>
<%@attribute name="reason" required="true"%>

<c:choose>
    <c:when test="${! empty hardwareStatusName}">
        <sql:query var="sidQ">
select id from HardwareStatus where name=?<sql:param value="${hardwareStatusName}"/>;
        </sql:query>
        <c:choose>
            <c:when test="${! empty hardwareStatusId}">
                <c:if test="${sidQ.rows[0].id != hardwareStatusId}">
                    <traveler:error message="Inconsistent Hardware status! 361968" bug="true"/>
                </c:if>
            </c:when>
            <c:otherwise>
                <c:set var="hardwareStatusId" value="${sidQ.rows[0].id}"/>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <c:if test="${empty hardwareStatusId}">
            <traveler:error message="No Hardware status! 442752" bug="true"/>
        </c:if>
    </c:otherwise>
</c:choose>

    <sql:update>
insert into HardwareStatusHistory set
hardwareStatusId=?<sql:param value="${hardwareStatusId}"/>,
hardwareId=?<sql:param value="${hardwareId}"/>,
<c:if test="${! empty activityId}">
    activityId=?<sql:param value="${activityId}"/>,
</c:if>
reason=?<sql:param value="${reason}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=UTC_TIMESTAMP();
    </sql:update>
