<%-- 
    Document   : limsRunTraveler
    Created on : Oct 15, 2015, 4:53:34 PM
    Author     : focke
--%>

<%@tag description="Run an automatable traveler from scripting API" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<traveler:findProcess var="processId" 
                      name="${inputs.name}" version="${inputs.version}"
                      hardwareGroup="${inputs.hardwareGroup}"/>

    <sql:query var="autoQ">
select travelerActionMask&(select maskBit from InternalAction where name='harnessedJob') as isHarnessed,
travelerActionMask&(select maskBit from InternalAction where name='automatable') as isAutomatable
from Process where id=?<sql:param value="${processId}"/>;
    </sql:query>
<c:set var="process" value="${autoQ.rows[0]}"/>
<c:if test="${process.isHarnessed==0 || process.isAutomatable==0}">
    <traveler:error message="Travler is neither automatable nor harnessed."/>
</c:if>

<ta:createTraveler var="activityId"
                   processId="${processId}" hardwareId="${inputs.hardwareId}"/>
