<%-- 
    Document   : newHardwareForm
    Created on : Jun 27, 2013, 12:22:40 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="hardwareTypeId"%>

<sql:query var="typesQ" dataSource="jdbc/rd-lsst-cam">
    select * from HardwareType
    <c:if test="${! empty hardwareTypeId}">
        where id=?<sql:param value="${hardwareTypeId}"/>
    </c:if>
    ;
</sql:query>

<form METHOD=GET ACTION="createHardware.jsp">

    <table>
        <tr>
            <td>LSST Id:</td>
            <td><INPUT TYPE=TEXT NAME=lsstId SIZE=50 autofocus></td>
        </tr>

        <tr>
            <td>Manufacturer:</td>
            <td><INPUT TYPE=TEXT NAME=manufacturer SIZE=50 autofocus></td>
        </tr>

        <tr>
            <td>Model:</td>
            <td><INPUT TYPE=TEXT NAME=model SIZE=50 autofocus></td>
        </tr>

        <tr>
            <td>Manufacture Date:</td>
            <td><input type="datetime"></td>
        </tr>

        <tr>
            <td>Type: </td>
            <td>
                <c:choose>
                    <c:when test="{$! empty hardwareTypeId}">
                        <input type="hidden" name="hardwareTypeId" value="${hardwareTypeId}"/>
                        <c:out value="${typesQ.rows[0].name}"/>
                    </c:when>
                    <c:otherwise>
                        <select name="hardwareTypeId">
                            <c:forEach var="tRow" items="${typesQ.rows}">
                                <option value="${tRow.id}">${tRow.name}</option>
                            </c:forEach>
                        </select>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>

    </table>    
<INPUT TYPE=SUBMIT value="Do It!">
</form>
