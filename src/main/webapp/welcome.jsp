<%@page contentType="text/html"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<html>
    <head>
        <title>Hello LLST</title>
    </head>
    <body>
        Howdy, ${empty userName?"stranger":userName}.<br>
        
        <table>
            <tr>
                <td>Role: ${empty sessionScope.role?"Unknown":sessionScope.role}</td>
                <td>
                    <form action="setRole.jsp" method="GET">
                        <select name="role">
                            <option value="Approver">Approver</option>
                            <option value="Supervisor">Supervisor</option>
                            <option value="Operator">Operator</option>
                            <option value="Spectator">Spectator</option>
                       </select>
                        <input type="submit" value="Change Role"/>
                    </form>
                </td>
            </tr>
        </table>
        
        <sql:query var="idAuthQ" dataSource="jdbc/rd-lsst-cam">
            select * from HardwareIdentifierAuthority;
        </sql:query>
        <table>
            <tr>
                <td>Site: ${empty sessionScope.siteName?"Unknown":sessionScope.siteName}</td>
                <td>
                    <form action="setSite.jsp" method="GET">
                        <select name="siteId">
                            <c:forEach var="iaRow" items="${idAuthQ.rows}">
                                <option value="${iaRow.id}">${iaRow.name}</option>
                            </c:forEach>
                        </select>
                        <input type="submit" value="Change Site"/>
                    </form>
                </td>
            </tr>
        </table>

        <h2>Recent Activity</h2>
        <traveler:activityList/>
    </body>
</html>