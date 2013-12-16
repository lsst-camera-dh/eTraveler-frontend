<%-- 
    Document   : fail
    Created on : Nov 13, 2013, 12:00:53 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>

<sql:update >
    update Activity set
    activityFinalStatusId=(select id from ActivityFinalStatus where name='failure'),
    end=now()
    where id=?<sql:param value="${activityId}"/>;
</sql:update>
    
<sql:query var="activityQ" >
    select * from Activity where id=?<sql:param value="${activityId}"/>;
</sql:query>
<c:if test="${! empty activityQ.rows[0].parentActivityId}">
    <traveler:failActivity activityId="${activityQ.rows[0].parentActivityId}"/>
</c:if>
    