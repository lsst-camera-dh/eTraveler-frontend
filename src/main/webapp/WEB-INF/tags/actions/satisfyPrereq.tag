<%-- 
    Document   : satisfyPrereq
    Created on : Jan 20, 2017, 3:43:38 PM
    Author     : focke
--%>

<%@tag description="satisfy a prerequisite" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="prerequisitePatternId" required="true"%>
<%@attribute name="activityId" required="true"%>
<%@attribute name="prerequisiteActivityId"%>
<%@attribute name="hardwareId"%>

<sql:update>
    insert into Prerequisite set
    prerequisitePatternId=?<sql:param value="${prerequisitePatternId}"/>,
    activityId=?<sql:param value="${activityId}"/>,
    <c:if test="${! empty prerequisiteActivityId}">
        prerequisiteActivityId=?<sql:param value="${prerequisiteActivityId}"/>,
    </c:if>
    <c:if test="${! empty componentId}">
        hardwareId=?<sql:param value="${componentId}"/>,
    </c:if>
    createdBy=?<sql:param value="${userName}"/>,
    creationTs=UTC_TIMESTAMP();
</sql:update>
