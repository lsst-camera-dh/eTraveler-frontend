<%-- 
    Document   : componentSelector
    Created on : Aug 20, 2015, 5:07:14 PM
    Author     : focke
--%>

<%@tag description="Pick a component" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="hardwareTypeId" required="true"%>
<%@attribute name="quantity" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="gotSome" scope="AT_BEGIN"%>

    <sql:query var="batchQ">
select isBatched from HardwareType where id=?<sql:param value="${hardwareTypeId}"/>;
    </sql:query>
<c:set var="isBatched" value="${batchQ.rows[0].isBatched != 0}"/>

    <sql:query var="componentsQ">
select H.id, H.lsstId
<c:if test="${isBatched}">
    , sum(BIH.adjustment) as nAvailable
</c:if>
from Hardware H
    inner join HardwareStatusHistory HSH on HSH.hardwareId=H.id and HSH.id=(select max(id) from HardwareStatusHistory where hardwareId=H.id)
<c:if test="${isBatched}">
    inner join BatchedInventoryHistory BIH on BIH.hardwareId=H.id
</c:if>
where H.hardwareTypeId=?<sql:param value="${hardwareTypeId}"/>
and HSH.hardwareStatusId=(select id from HardwareStatus where name='READY')
<c:if test="${isBatched}">
    group by H.id
    having nAvailable>=?<sql:param value="${quantity}"/>
</c:if>
;
    </sql:query>

<c:choose>
    <c:when test="${empty componentsQ.rows}">
        <c:set var="gotSome" value="false"/>
        We're out.
    </c:when>
    <c:otherwise>
        <c:set var="gotSome" value="true"/>
        <select name="minorId">
            <c:forEach var="hRow" items="${componentsQ.rows}">
                <option value="${hRow.id}">${hRow.lsstId} <c:if test="${isBatched}">(${hRow.nAvailable})</c:if></option>
            </c:forEach>
        </select>
    </c:otherwise>
</c:choose>
