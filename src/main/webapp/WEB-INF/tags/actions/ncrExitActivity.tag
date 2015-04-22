<%-- 
    Document   : ncrExitActivity
    Created on : Oct 2, 2014, 3:02:17 PM
    Author     : focke
--%>

<%@tag description="put an Activity in ncrExit state" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="activityId" required="true"%>

<sql:query var="activityQ">
    select * from Activity where id=?<sql:param value="${activityId}"/>;
</sql:query>
<c:set var="notStarted" value="${empty activityQ.rows[0].begin}"/>

<sql:update>
    update Activity set
    <c:if test="${notStarted}">begin=UTC_TIMESTAMP(),</c:if>
        end=UTC_TIMESTAMP(),
        activityFinalStatusId=(select id from ActivityFinalStatus where name='ncrExit'),
        closedBy=?<sql:param value="${userName}"/>
    where
        id=?<sql:param value="${activityId}"/>;
</sql:update>
