<%-- 
    Document   : options
    Created on : Mar 6, 2015, 11:26:35 AM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>eTraveler user options</title>
    </head>
    <body>
        <h1>Hello <c:out value="${userName}"/>!</h1>
        
        <sql:query var="roleQ">
            select id, name from PermissionGroup
        </sql:query>
        <table>
            <tr>
                <td>Role: ${empty sessionScope.role?"Unknown":sessionScope.role}</td>
                <td>
                    <form action="fh/setRole.jsp" method="GET">
                        <select name="role">
                            <%--
                            <option value="Admin">Admin</option>
                            <option value="Approver">Approver</option>
                            <option value="Supervisor">Supervisor</option>
                            <option value="Operator">Operator</option>
                            <option value="Spectator" selected>Spectator</option>
                            --%>
                            <c:forEach var="pgRow" items="${roleQ.rows}">
                                <c:if test="${empty sessionScope.role or pgRow.name!=sessionScope.role}">
                                    <option value="${pgRow.name}">${pgRow.name}</option>
                                </c:if>
                            </c:forEach>
                            
                       </select>
                        <input type="submit" value="Change Role"/>
                    </form>
                </td>
            </tr>
        </table>
        
        <sql:query var="siteQ" >
            select id, name from Site;
        </sql:query>
        <table>
            <tr>
                <td>Site: ${empty sessionScope.siteName?"Unknown":sessionScope.siteName}</td>
                <td>
                    <form action="fh/setSite.jsp" method="GET">
                        <select name="siteId">
                            <c:forEach var="sRow" items="${siteQ.rows}">
                                <c:if test="${empty sessionScope.siteName or sRow.name!=sessionScope.siteName}">
                                    <option value="${sRow.id}">${sRow.name}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <input type="submit" value="Change Site"/>
                    </form>
                </td>
            </tr>
        </table>

        <sql:query var="idAuthQ" >
            select id, name from HardwareIdentifierAuthority;
        </sql:query>
        <table>
            <tr>
                <td>Default Identifier Authority: ${empty sessionScope.idAuthName?"Unknown":sessionScope.idAuthName}</td>
                <td>
                    <form action="fh/setIdAuth.jsp" method="GET">
                        <select name="idAuthId">
                            <c:forEach var="iaRow" items="${idAuthQ.rows}">
                                <option value="${iaRow.id}">${iaRow.name}</option>
                            </c:forEach>
                        </select>
                        <input type="submit" value="Change Identifier Authority"/>
                    </form>
                </td>
            </tr>
        </table>

    </body>
</html>
