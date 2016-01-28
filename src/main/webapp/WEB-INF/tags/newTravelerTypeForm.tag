<%-- 
    Document   : newTravelerTypeForm
    Created on : Apr 6, 2015, 10:18:50 AM
    Author     : focke
--%>

<%@tag description="A form to make a new TravelerType" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="processId"%>

<traveler:checkPerm var="mayApprove" groups="EtravelerApprover"/>

    <sql:query var="subsysQ">
select id, name from Subsystem;
    </sql:query>

    <sql:query var="processQ">
select id, name 
from Process 
where id not in (select rootProcessId from TravelerType)
<c:if test="${! empty processId}">and id=?<sql:param value="${processId}"/></c:if>
order by name
;
    </sql:query>

<c:if test="${! empty processQ.rows}">
    
    <c:choose>
        <c:when test="${! empty processId}">
Make this step a process traveler entry point            
        </c:when>
        <c:otherwise>
This makes a substep of an existing process traveler usable as the entry point to a process traveler in its own right.<br>
The interface here is terrible, if you have ideas on improving it, please share!            
        </c:otherwise>
    </c:choose>

<form method="get" action="approver/addTravelerType.jsp">
    <input type="submit" value="Add Process Traveler Entry Point"
           <c:if test="${! mayApprove}">disabled</c:if>>
    Root Process: 
    <c:choose>
        <c:when test="${! empty processId}">
            <input type="hidden" name="rootProcessId" value="<c:out value="${processId}"/>">
            <c:out value="${processQ.rows[0].name}"/>
        </c:when>
        <c:otherwise>
            <select name="rootProcessId">
                <c:forEach var="process" items="${processQ.rows}">
                    <option value="${process.id}"><c:out value="${process.name}"/></option>
                </c:forEach>
            </select>            
        </c:otherwise>
    </c:choose>
    Subsystem:&nbsp;<select name="subsystemId" required>
        <option value="0" <c:if test="${preferences.subsystem == 'Any'}">selected</c:if> disabled>Select Subsystem</option>
        <c:forEach var="subsystem" items="${subsysQ.rows}">
            <option value="${subsystem.id}" <c:if test="${subsystem.name == preferences.subsystem}">selected</c:if>>${subsystem.name}</option>
        </c:forEach>
    </select>
    Owner: <input type="text" name="owner">
    Reason: <textarea name="reason"></textarea>
</form>

</c:if>
