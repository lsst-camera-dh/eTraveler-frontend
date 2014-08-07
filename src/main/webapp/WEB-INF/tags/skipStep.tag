<%-- 
    Document   : skipStep
    Created on : Aug 7, 2014, 11:20:27 AM
    Author     : focke
--%>

<%@tag description="Skip a step." pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%@attribute name="processId" required='true'%>
<%@attribute name="hardwareId" required="true"%>
<%@attribute name="parentProcessId" required="true"%>
<%@attribute name="processEdgeId" required="true"%>
<%@attribute name="inNCR" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="activityId" scope="AT_BEGIN"%>

<sql:transaction>
    <sql:update>
        insert into Activity set
        hardwareId=?<sql:param value="${hardwareId}"/>,
        processId=?<sql:param value="${processId}"/>,
        processEdgeId=?<sql:param value="${processEdgeId}"/>,
        parentActivityId=?<sql:param value="${parentActivityId}"/>,
        activityFinalStatusId=(select id from ActivityFinalStatus where name='skipped'),
        begin=now(),
        end=now(),
        inNCR=?<sql:param value="${inNCR}"/>,
        createdBy=?<sql:param value="${userName}"/>,
        closedBy=?<sql:param value="${userName}"/>,
        creationTS=now();
    </sql:update>
    <sql:query var="activityQ">
        select LAST_INSERT_ID() as activityId;
    </sql:query>
</sql:transaction>

<c:set var="activityId" value="${activityQ.rows[0].activityId}"/>
