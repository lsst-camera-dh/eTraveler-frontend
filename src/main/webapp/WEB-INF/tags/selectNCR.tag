<%-- 
    Document   : findNCRs
    Created on : Jun 23, 2014, 2:21:24 PM
    Author     : focke
--%>

<%@tag description="Pick an NCR to exit from a stopped Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>
<traveler:findPath var="edgePath" activityId="${activityId}"/>

<sql:query var="ncrQ">
    select * from ExceptionType
    where 
    exitProcessPath=?<sql:param value="${edgePath}"/>
    and status='ENABLED';
</sql:query>

<form method="get" action="doNCR.jsp" target="_top">
    <input type="hidden" name="activityId" value="${activityId}">
    <select name="exceptionTypeId">
        <c:forEach var="et" items="${ncrQ.rows}">
            <option value="${et.id}">${et.conditionString}</option>
        </c:forEach>
    </select>
    <INPUT TYPE=SUBMIT 
        <c:choose>
           <c:when test="${! empty ncrQ.rows}">
               value="Enter NCR"
           </c:when>
           <c:otherwise>
               value="No NCRs defined" disabled
           </c:otherwise>
        </c:choose>
               >
</form>
