<%-- 
    Document   : createTraveler
    Created on : Jan 30, 2013, 2:22:04 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@page import = "java.util.Date,java.text.SimpleDateFormat,java.text.ParseException"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Create Hardware</title>
    </head>
    <body>
<%
String dateStr = request.getParameter("manufactureDateDate");  
SimpleDateFormat formater = new SimpleDateFormat("dd/MM/yyyy");
Date result = formater.parse(dateStr);
request.setAttribute("manufactureDate", result);
%>
        <sql:transaction >
            <c:if test="${empty param.lsstId}">
                <sql:update>
                    update HardwareType set autoSequence=LAST_INSERT_ID(autoSequence+1)
                    where id=?<sql:param value="${param.hardwareTypeId}"/>;
                </sql:update>
            </c:if>
            <sql:update>
                insert into Hardware set
                <c:choose>
                    <c:when test="${! empty param.lsstId}">
                lsstId=?<sql:param value="${param.lsstId}"/>,
                    </c:when>
                    <c:otherwise>
                lsstId=concat(
                    ?<sql:param value="${param.typeName}"/>,
                    '-',
                    LPAD(LAST_INSERT_ID(), ?<sql:param value="${param.autoSequenceWidth}"/>, '0')
                ),
                    </c:otherwise>
                </c:choose>
                hardwareTypeId=?<sql:param value="${param.hardwareTypeId}"/>,
                manufacturer=?<sql:param value="${param.manufacturer}"/>,
                model=?<sql:param value="${param.model}"/>,
                manufactureDate=?<sql:dateParam value="${manufactureDate}"/>,
                hardwareStatusId=(select id from HardwareStatus where name="NEW"),
                createdBy=?<sql:param value="${userName}"/>,
                creationTS=UTC_TIMESTAMP();
            </sql:update>
            <sql:query var="hardwareQ">
                select id from Hardware where id=LAST_INSERT_ID();
            </sql:query>
            <sql:update>
                insert into HardwareStatusHistory set
                hardwareStatusId=(select id from HardwareStatus where name="NEW"),
                hardwareId=LAST_INSERT_ID(),
                createdBy=?<sql:param value="${userName}"/>,
                creationTS=UTC_TIMESTAMP();
            </sql:update>
            <c:set var="hardware" value="${hardwareQ.rows[0]}"/>
            <sql:update>
                insert into HardwareLocationHistory set
                locationId=?<sql:param value="${param.locationId}"/>,
                hardwareId=?<sql:param value="${hardware.id}"/>,
                createdBy=?<sql:param value="${userName}"/>,
                creationTS=UTC_TIMESTAMP();
            </sql:update>
        </sql:transaction>
        <c:redirect url="/displayHardware.jsp" context="/eTraveler">
            <c:param name="hardwareId" value="${hardware.id}"/>
        </c:redirect>
    </body>
</html>
