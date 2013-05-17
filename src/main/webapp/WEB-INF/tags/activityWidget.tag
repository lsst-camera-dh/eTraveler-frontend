<%-- 
    Document   : activityWidget
    Created on : May 17, 2013, 1:16:30 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId"%>

<sql:query var="activityQ" dataSource="jdbc/rd-lsst-cam">
    select * from Activity where id=?<sql:param value="${param.activityId}"/>;
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

Started at <c:out value="${activity.begin}"/> by <c:out value="${activity.createdBy}"/>
<br>
<c:if test="${! empty activity.end}">
    Ended at <c:out value="${activity.end}"/> by <c:out value="${activity.closedBy}"/>
</c:if>