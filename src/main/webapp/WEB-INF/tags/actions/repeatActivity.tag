<%-- 
    Document   : repeatActivity
    Created on : Feb 20,2014 15:19 PST
    Author     : focke
--%>

<%@tag description="Do an Activity again" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>

<%@attribute name="activityId" required="true"%>

<sql:query var="activityQ" >
    select A.*
    from Activity A
    where A.id=?<sql:param value="${activityId}"/>;
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<ta:createActivity var="newActivityId"
    hardwareId="${activity.hardwareId}"
    processId="${activity.processId}"
    processEdgeId="${activity.processEdgeId}"
    parentActivityId="${activity.parentActivityId}"
    iteration="${activity.iteration + 1}"
    inNCR="${activity.inNCR}"
/>

<ta:closeoutActivity activityId="${activityId}"/>
