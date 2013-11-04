<%-- 
    Document   : limsIdCheck
    Created on : Oct 31, 2013, 4:48:46 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%@attribute name="jobId" required="true"%>

<sql:query var="actionQ" dataSource="jdbc/rd-lsst-cam">
    select P.travelerActionMask
    from Process P
    inner join Activity A on A.processId=?<sql:param value="${jobId}"/>
</sql:query>
