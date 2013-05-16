<%@page contentType="text/html"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<html>
    <head>
        <title>Hello LLST</title>
    </head>
    <body>
        Howdy, ${empty userName?"stranger":userName}.<br>
        
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
    </body>
</html>