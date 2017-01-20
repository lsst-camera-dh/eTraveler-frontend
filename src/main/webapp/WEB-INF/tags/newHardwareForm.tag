<%-- 
    Document   : newHardwareForm
    Created on : Jun 27, 2013, 12:22:40 PM
    Author     : focke
--%>

<%@tag description="Display a form to register a new component" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="time" uri="http://srs.slac.stanford.edu/time"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="hardwareTypeId" required="true"%>

<traveler:checkSsPerm var="mayOperate" hardwareTypeId="${hardwareTypeId}" roles="operator,supervisor"/>

<sql:query var="typeQ" >
    select * from HardwareType
    where id=?<sql:param value="${hardwareTypeId}"/>;
</sql:query>
<c:set var="hType" value="${typeQ.rows[0]}"/>

<sql:query var="locationQ">
    select 
        L.id as locationId, L.name as locationName, S.name as siteName
    from
        Location L
        inner join Site S on L.siteId=S.id
        where S.name=?<sql:param value="${preferences.siteName}"/>
    order by
        S.name, L.name
    ;
</sql:query>

    <h2>Register new <c:if test="${hType.isBatched != 0}">batch of</c:if> ${hType.name}</h2>
<form METHOD=GET ACTION="operator/createHardware.jsp" name="hwSpex">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">

    <table>
        <c:if test="${hType.autoSequenceWidth==0}">
            <tr>
                <td>${appVariables.experiment} Serial Number:</td>
                <td>*<INPUT TYPE="TEXT" NAME="lsstId" SIZE=50 autofocus required></td>
            </tr>
        </c:if>
        <c:if test="${hType.isBatched != 0}">
            <tr>
                <td>Quantity:</td><td>*<input type="number" name="quantity" min="1" required></td>
            </tr>
        </c:if>
        <tr>
            <td>Manufacturer:</td>
            <td>*<INPUT TYPE=TEXT NAME=manufacturer SIZE=50 autofocus required></td>
        </tr>
        <tr>
            <td>Manufacturer Serial Number:</td>
            <td><input type="text" name="manufacturerId" size="50"></td>
        </tr>
        <tr>
            <td>Model:</td>
            <td><INPUT TYPE=TEXT NAME=model SIZE=50 autofocus></td>
        </tr>
        <tr>
            <td>Manufacture Date<br>(yyyy-mm-dd):</td>
            <td>
                <time:dateTimePicker value="${time:now('UTC')}" showtime="false" size="18" name="manufactureDate"  timezone="UTC"
format="%Y-%m-%d" shownone="true"/>
            </td>
        </tr>
        <tr>
            <td>Location:</td>
            <td>
                <select name="locationId">
                    <c:forEach var="loc" items="${locationQ.rows}">
                        <option value="${loc.locationId}">${loc.siteName} ${loc.locationName}</option>
                    </c:forEach>
                </select>
            </td>
        </tr>
        <tr>
            <td>Remark:</td>
            <td><INPUT TYPE=TEXT NAME=remarks SIZE=50 autofocus></td>
        </tr>
    </table>    
    <input type="hidden" name="hardwareTypeId" value="${hardwareTypeId}"/>
    <c:set var="what" value="${hType.isBatched == 0 ? 'Component' : 'Batch'}"/>
    <INPUT TYPE=SUBMIT value="Register ${what}"
        <c:if test="${! mayOperate}">disabled</c:if>>
</form>
