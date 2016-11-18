<%-- 
    Document   : genericApplicableLabel
    Created on : Nov 15, 2016, 11:24 AM
    Author     : jrb
--%>

<%@tag description="Return list of label ids for labels which may be or are applied to object"
       pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="objectId" required="true"%>
<%@attribute name="objectTypeId" required="true"%>

<%-- find subsystem, if any, applying to object --%>
<sql:query var="subsysId">
   call generic_subsystem (<sql:param value="${objectId}"/>, <sql:param value="${param.objectTypeId}"/>)
</sql:query>

<%-- find hardware groups applying to object, if any --%>
<sql:query var="hgroupId">
   call generic_hardwareGroup (<sql:param value="${objectId}"/>, <sql:param value="${objectTypeId}"/>)
</sql:query>

<traveler:fullRequestString var="thisPage"/>    <%-- What's this about? --%>
