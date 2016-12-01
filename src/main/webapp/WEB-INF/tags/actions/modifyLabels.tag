<%-- 
    Document   : modifyLabels.tag
    Created on : Nov. 30, 2016
    Author     : jrb
--%>

<%@tag description="Change labels on something" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="objectId" required="true"%>
<%@attribute name="objectTypeId" required="true"%>
<%@attribute name="labelId"%>
<%-- <%@attribute name="hardwareStatusName"%>  --%>
<%@attribute name="activityId"%>
<%@attribute name="reason" required="true"%>
<%@attribute name="removeLabel"%>

<c:if test="${empty removeLabel}">
    <c:set var="removeLabel" value="false"/>
</c:if>

<%--
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
--%>

    <sql:update>
insert into LabelHistory set
labelId=?<sql:param value="${labelId}"/>,
objectId=?<sql:param value="${objectId}"/>,
labelableId=?<sql:param value="${objectTypeId}"/>,
<c:if test="${! empty activityId}">
    activityId=?<sql:param value="${activityId}"/>,
</c:if>
reason=?<sql:param value="${reason}"/>,
<c:if test="${removeLabel}">
    adding=0,
</c:if>
createdBy=?<sql:param value="${userName}"/>,
creationTS=UTC_TIMESTAMP();
    </sql:update>
