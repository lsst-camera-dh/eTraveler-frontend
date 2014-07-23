<%-- 
    Document   : newHardwareForm
    Created on : Jun 27, 2013, 12:22:40 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib uri="http://srs.slac.stanford.edu/time" prefix="time" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="hardwareTypeId" required="true"%>

<sql:query var="typeQ" >
    select * from HardwareType
    where id=?<sql:param value="${hardwareTypeId}"/>;
</sql:query>
<c:set var="hType" value="${typeQ.rows[0]}"/>

<h2>Register new ${hType.name}</h2>
<form METHOD=GET ACTION="fh/createHardware.jsp" name="hwSpex">

    <table>
        <c:choose>
            <c:when test="${hType.autoSequenceWidth==0}">
                <tr>
                    <td>Serial:</td>
                    <td>*<INPUT TYPE="TEXT" NAME="lsstId" SIZE=50 autofocus required></td>
                </tr>
            </c:when>
            <c:otherwise>
                <INPUT TYPE="hidden" NAME="autoSequenceWidth" value="${hType.autoSequenceWidth}"/>
                <INPUT TYPE="hidden" NAME="typeName" value="${hType.name}"/>
            </c:otherwise>
        </c:choose>
        <tr>
            <td>Manufacturer:</td>
            <td>*<INPUT TYPE=TEXT NAME=manufacturer SIZE=50 autofocus required></td>
        </tr>
        <tr>
            <td>Model:</td>
            <td><INPUT TYPE=TEXT NAME=model SIZE=50 autofocus></td>
        </tr>
        <tr>
            <td>Manufacture Date<br>(dd/mm/yyyy):</td>
            <td>
                <time:dateTimePicker value="${time:now('PST')}" showtime="false" size="18" name="manufactureDate"  timezone="PST"
shownone="true"/>
            </td>
        </tr>
        <tr>
    </table>    
    <input type="hidden" name="hardwareTypeId" value="${hardwareTypeId}"/>
    <INPUT TYPE=SUBMIT value="Register Component">
</form>
