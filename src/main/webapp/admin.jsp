<%-- 
    Document   : admin
    Created on : Oct 3, 2013, 2:57:59 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        
        <form method="get" action="fh/addSite.jsp">
            <input type="submit" value="Add Site">
            Name: <input type="text" name="name" required>
            jhVirtualEnv: <input type="text" name="jhVirtualEnv">
            jhOutputRoot: <input type="text" name="jhOutputRoot">
        </form>
            
        <sql:query var="sitesQ" >
            select id, name from Site
        </sql:query>
        <form method="get" action="fh/addLocation.jsp">
            <input type="submit" value="Add Location">
            Name: <input type="text" name="name" required>
            Site: <select name="siteId">
                <c:forEach var="siteRow" items="${sitesQ.rows}">
                    <option value="${siteRow.id}" <c:if test="${! empty sessionScope.siteName and sessionScope.siteName==siteRow.name}">selected</c:if>>${siteRow.name}</option>
                </c:forEach>
            </select>
        </form>

        <form method="get" action="fh/addHardwareType.jsp">
            <input type="submit" value="Add Hardware Type">
            Name: <input type="text" name="name" required>
            Drawing: <input type="text" name="drawing">
        </form>
            
        <sql:query var="hardwareTypesQ" >
            select id, name from HardwareType
        </sql:query>
        <form method="get" action="fh/addHardwareRelationshipType.jsp">
            <input type="submit" value="Add Hardware Relationship Type">
            Name: <input type="text" name="name" required>
            Hardware Type: <select name="hardwareTypeId">
                <c:forEach var="htRow" items="${hardwareTypesQ.rows}">
                    <option value="${htRow.id}">${htRow.name}</option>
                </c:forEach>
            </select>
            Component Type: <select name="componentTypeId">
                <c:forEach var="htRow" items="${hardwareTypesQ.rows}">
                    <option value="${htRow.id}">${htRow.name}</option>
                </c:forEach>
            </select>
        </form>

        <form method="get" action="fh/addHardwareIdentifierAuthority.jsp">
            <input type="submit" value="Add Hardware Identifier Authority">
            Name: <input type="text" name="name" required>
        </form>
            
    </body>
</html>
