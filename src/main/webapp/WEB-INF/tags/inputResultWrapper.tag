<%-- 
    Document   : inputResultWrapper
    Created on : Nov 17, 2015, 6:55:27 PM
    Author     : focke
--%>

<%@tag description="A simpler interface to inputResult" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="inputName" required="true"%>
<%@attribute name="value" required="true"%>

    <sql:query var="patternQ">
select IP.id
from Activity A
inner join Process P on P.id=A.processId
inner join InputPattern IP on IP.processId=P.id
where A.id=?<sql:param value="${activityId}"/>
and IP.label=?<sql:param value="${inputName}"/>
;
    </sql:query>
<c:if test="${empty patternQ.rows}">
    <traveler:error message="No input pattern with name=${inputName} for activity ${activityId} found"/>
</c:if>
<c:set var="pattern" value="${patternQ.rows[0]}"/>

<ta:inputResult activityId="${activityId}" inputPatternId="${pattern.id}" value="${value}"/>
