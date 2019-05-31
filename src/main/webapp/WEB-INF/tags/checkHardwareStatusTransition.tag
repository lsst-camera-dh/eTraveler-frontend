<%-- 
    Document   : checkHardwareStatusTransition
    Created on : May 28, 2019
    Author     : jrb

    Check requested (manual) transition is allowed: cannot involve status 'USED'
    Cannot change out of 'REJECTED'
--%>

<%@tag description="Check whether manual change from one hardware status to another is allowed" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="hardwareId" required="true" %>
<%@attribute name="newStatusId"  required="true" %>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="allowed" scope="AT_BEGIN"%>

<c:set var="allowed" value="true"/>

<sql:query var="oldStatusQ">
select name from HardwareStatus HS join Hardware H on hardwareStatusId = HS.id where
  H.id=?<sql:param value="${hardwareId}"/>
</sql:query>

<c:choose>
  <c:when test="${oldStatusQ.rows[0].name == 'USED' }">
      <c:set var="allowed" value="false" />
  </c:when>
  <c:when test="${oldStatusQ.rows[0].name == 'REJECTED' }">
      <c:set var="allowed" value="false" />
  </c:when>

  <c:otherwise>
    <sql:query var="newStatusQ">
      select name from HardwareStatus where id=?<sql:param value="${newStatusId}"/>
    </sql:query>

    <c:if test="${newStatusQ.rows[0].name == 'USED' }">
        <c:set var="allowed" value="false" />
    </c:if>
  </c:otherwise>
</c:choose>
