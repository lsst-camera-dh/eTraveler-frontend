<%-- 
    Document   : createActivity
    Created on : Jan 29, 2013, 11:12:46 AM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>JSP Page</title>
    </head>
    <body>
        <sql:transaction >
            <sql:update>
                insert into Activity set
                hardwareId=?<sql:param value="${param.hardwareId}"/>,
                processId=?<sql:param value="${param.processId}"/>,
                processEdgeId=?<sql:param value="${param.processEdgeId}"/>,
                parentActivityId=?<sql:param value="${param.parentActivityId}"/>,
                inNCR=?<sql:param value="${param.inNCR}"/>,
                createdBy=?<sql:param value="${userName}"/>,
                creationTS=NOW();
           </sql:update>
<%--
           <sql:query var="activityQ">
               select * from Activity where id=LAST_INSERT_ID()                
           </sql:query>
--%>
        </sql:transaction>
<%--
        <c:redirect url="displayActivity.jsp">
            <c:param name="activityId" value="${activityQ.rows[0]['id']}"/>
        </c:redirect>
--%>
        <c:redirect url="${header.referer}"/>
    </body>
</html>
