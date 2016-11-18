<%-- 
    Document   : activityInputWidget
    Created on : Dec 12, 2013, 10:53:20 AM
    Author     : focke
--%>

<%@tag description="Handle manual inputs for an Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="resultsFiled" scope="AT_BEGIN"%>

<traveler:getActivityStatus var="status" varFinal="isFinal" activityId="${activityId}"/>

<c:choose>
    <c:when test="${status == 'inProgress'}">
        <c:set var="resultsFiled" value="true"/> <%-- will get set to false if any are not --%>
    </c:when>
    <c:otherwise>
        <c:set var="resultsFiled" value="false"/>
    </c:otherwise>
</c:choose>

    <sql:query var="inputQ" >
select count(*) as count
from Activity A
inner join InputPattern IP on IP.processId=A.processId
inner join InputSemantics ISm on ISm.id=IP.inputSemanticsId
where A.id=?<sql:param value="${activityId}"/>
and ISm.name != 'signature'
;
    </sql:query>

<c:if test="${inputQ.rows[0].count != 0}">
    <h2>Instructions and Results</h2>
    <traveler:activityInputTable var="resultsFiled" activityId="${activityId}" optional="0"/>
    <traveler:activityInputTable var="junk" activityId="${activityId}" optional="1"/>
</c:if>
