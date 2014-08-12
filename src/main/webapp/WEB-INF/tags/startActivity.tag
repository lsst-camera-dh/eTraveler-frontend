<%-- 
    Document   : startActivity
    Created on : Aug 8, 2014, 1:16:56 PM
    Author     : focke
--%>

<%@tag description="Start an existing Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%@attribute name="activityId" required="true"%>

<sql:update >
    update Activity set
    begin=now()
    where id=?<sql:param value="${activityId}"/>
    and begin is null;
</sql:update>
