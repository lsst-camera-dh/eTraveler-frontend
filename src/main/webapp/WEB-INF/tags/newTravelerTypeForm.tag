<%-- 
    Document   : newTravelerTypeForm
    Created on : Apr 6, 2015, 10:18:50 AM
    Author     : focke
--%>

<%@tag description="A form to make a new TravelerType" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="processId"%>

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

<form method="get" action="fh/addTravelerType.jsp">
    <input type="submit" value="Add Process Traveler Entry Point">
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
    Owner: <input type="text" name="owner">
    Reason: <textarea name="reason"></textarea>
</form>

</c:if>
