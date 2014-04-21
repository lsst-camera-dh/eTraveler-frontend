<%-- 
    Document   : newTravelerForm.tag
    Created on : Jan 24, 2014, 2:51:15 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%@attribute name="hardwareTypeId" required="true"%>
<%@attribute name="processId"%>
<%@attribute name="hardwareId"%>

<sql:query var="processQ" >
    select P.id, concat(P.name, ' v', P.version) as versionedName
    from Process P
    left join ProcessEdge PE on PE.child=P.id
    where 
    <c:choose>
        <c:when test="${empty processId}">
    P.hardwareTypeId=?<sql:param value="${hardwareTypeId}"/>
        </c:when>
        <c:otherwise>
    P.id=?<sql:param value="${processId}"/>  
        </c:otherwise>
    </c:choose>
    and PE.child is null
    ;
</sql:query>
    
<sql:query var="hardwareQ" >
    select H.id, H.lsstId
    from Hardware H
    where 
    <c:choose>
        <c:when test="${empty hardwareId}">
    H.hardwareTypeId=?<sql:param value="${hardwareTypeId}"/>
        </c:when>
        <c:otherwise>
    H.id=?<sql:param value="${hardwareId}"/>  
        </c:otherwise>
    </c:choose>
    ;
</sql:query>
   
<form METHOD=GET ACTION="fh/createTraveler.jsp">
    <input type="hidden" name="inNCR" value="FALSE">
    <table>
        <tr>
            <td>
    Traveler Type:
            </td>
            <td>
    <c:choose>
        <c:when test="${empty processId}">
            <select name="processId">
                <c:forEach var="pRow" items="${processQ.rows}">
                    <option value="${pRow.id}">${pRow.versionedName}</option>
                </c:forEach>
            </select>
        </c:when>
        <c:otherwise>
            <input type="hidden" name="processId" value="${processQ.rows[0].id}">
            <c:out value="${processQ.rows[0].versionedName}"/>
        </c:otherwise>
    </c:choose>
            </td>
        </tr>
        <tr>
            <td>
    Component:
            </td>
            <td>
    <c:choose>
        <c:when test="${empty hardwareId}">
            <select name="hardwareId">
                <c:forEach var="hRow" items="${hardwareQ.rows}">
                    <option value="${hRow.id}">${hRow.lsstId}</option>
                </c:forEach>
            </select>
        </c:when>
        <c:otherwise>
            <input type="hidden" name="hardwareId" value="${hardwareQ.rows[0].id}">
            <c:out value="${hardwareQ.rows[0].lsstId}"/>
        </c:otherwise>
    </c:choose>
            </td>
        </tr>
    </table>
    <INPUT TYPE=SUBMIT value="Initiate Traveler">
</form>
