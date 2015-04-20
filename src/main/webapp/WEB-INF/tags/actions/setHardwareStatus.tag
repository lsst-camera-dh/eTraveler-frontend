<%-- 
    Document   : setHardwareStatus
    Created on : Jun 27, 2013, 2:44:09 PM
    Author     : focke
--%>

<%@tag description="Change the status of a component" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="hardwareId" required="true"%>
<%@attribute name="hardwareStatusId" required="true"%>

<sql:update>
    insert into HardwareStatusHistory set
    hardwareStatusId=?<sql:param value="${hardwareStatusId}"/>,
    hardwareId=?<sql:param value="${hardwareId}"/>,
    createdBy=?<sql:param value="${userName}"/>,
    creationTS=UTC_TIMESTAMP();
</sql:update>
