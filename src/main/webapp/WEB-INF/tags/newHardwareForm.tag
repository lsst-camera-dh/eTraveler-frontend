<%-- 
    Document   : newHardwareForm
    Created on : Jun 27, 2013, 12:22:40 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="hardwareTypeId" required="true"%>

    <%--
    <script language="JavaScript" src="http://srs.slac.stanford.edu/Commons/scripts/FSdateSelect.jsp"></script>
    <link rel="stylesheet" href="http://srs.slac.stanford.edu/Commons/css/FSdateSelect.css" type="text/css">
    --%>
<sql:query var="typeQ" >
    select * from HardwareType
    where id=?<sql:param value="${hardwareTypeId}"/>;
</sql:query>
<c:set var="hType" value="${typeQ.rows[0]}"/>

<h2>Register new ${hType.name}</h2>
<form METHOD=GET ACTION="fh/createHardware.jsp">

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
            <td>Manufacture Date<br>(yyyy-mm-dd hh:mm:ss):</td>
            <td><input type="datetime" name="manufactureDate"></td>
            <%--<td>
            <script language="JavaScript">
                FSfncWriteFieldHTML("DateForm","manufactureDate","${empty date ? 'None' : manufactureDate}",100,
                "http://srs.slac.stanford.edu/Commons/images/FSdateSelector/","US",false,true);
            </script>
            </td>--%>
        </tr>
        <tr>
    </table>    
    <input type="hidden" name="hardwareTypeId" value="${hardwareTypeId}"/>
    <INPUT TYPE=SUBMIT value="Do It!">
</form>
