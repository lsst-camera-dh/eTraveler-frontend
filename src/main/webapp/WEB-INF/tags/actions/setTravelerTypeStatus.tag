<%-- 
    Document   : setTravelerTypeStatus
    Created on : Apr 6, 2015, 11:10:32 AM
    Author     : focke
--%>

<%@tag description="Change the status of a TravelerType" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="travelerTypeId" required="true"%>
<%@attribute name="stateId" required="true"%>
<%@attribute name="reason"%>

    <sql:update>
insert into TravelerTypeStateHistory set
reason=?<sql:param value="${reason}"/>,
travelerTypeId=?<sql:param value="${travelerTypeId}"/>,
travelerTypeStateId=?<sql:param value="${stateId}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=utc_timestamp();
    </sql:update>