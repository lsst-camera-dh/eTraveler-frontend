<%-- 
    Document   : setTravelerTypeStatus
    Created on : Apr 6, 2015, 11:10:32 AM
    Author     : focke
--%>

<%@tag description="Change the status of a TravelerType" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="travelerTypeId" required="true"%>
<%@attribute name="status" required="true"%>

<sql:update>
    update TravelerType set state=?<sql:param value="${status}"/> where id=?<sql:param value="${travelerTypeId}"/>;
</sql:update>

