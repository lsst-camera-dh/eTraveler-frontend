<%@page contentType="text/html"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<html>
    <head>
        <title>Hello ${appVariables.experiment}</title>
    </head>
    <body>
        Welcome, ${empty userName?"stranger":userName}.<br>
        
        <table>
            <tr>
                <td>Role: ${empty sessionScope.role?"Unknown":sessionScope.role}</td>
                <td>
                    <form action="fh/setRole.jsp" method="GET">
                        <select name="role">
                            <option value="Admin">Admin</option>
                            <option value="Approver">Approver</option>
                            <option value="Supervisor">Supervisor</option>
                            <option value="Operator">Operator</option>
                            <option value="Spectator" selected>Spectator</option>
                       </select>
                        <input type="submit" value="Change Role"/>
                    </form>
                </td>
            </tr>
        </table>
        
        <sql:query var="siteQ" >
            select * from Site;
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
            select * from HardwareIdentifierAuthority;
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

        <h2>Recent Activity</h2>
        <traveler:activityList/>
    </body>
</html>