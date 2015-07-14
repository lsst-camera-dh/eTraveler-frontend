<%-- 
    Document   : adjustBatchInventory
    Created on : Jul 14, 2015, 1:01:38 PM
    Author     : focke
--%>

<%@tag description="Add or subtract items in a batch" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="hardwareId" required="true"%>
<%@attribute name="adjustment" required="true"%>
<%@attribute name="reason"%>
<%@attribute name="activityId"%>

    <sql:update>
insert into BatchedInventoryHistory set 
harwareId=?<sql:param value="${param.harwareId}"/>,
adjustment=?<sql:param value="${param.adjustment}"/>,
<c:if test="${! empty param.reason}">
    reason=?<sql:param value="${param.reason}"/>,
</c:if>
<c:if test="${! empty param.activityId}">
    activityId=?<sql:param value="${param.activityId}"/>,
</c:if>
createdBy=?<sql:param value="${userName}"/>,
creationTS=utc_timestamp();
    </sql:update>
