<%-- 
    Document   : findNCRs
    Created on : Jun 23, 2014, 2:21:24 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>
<%--
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="ncrs" scope="AT_BEGIN"%>
--%>
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
