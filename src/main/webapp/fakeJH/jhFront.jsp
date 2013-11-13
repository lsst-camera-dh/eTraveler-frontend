<%-- 
    Document   : register
    Created on : Nov 11, 2013, 3:17:52 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <table border="1"><tr>
                <td>
                    <h2>Register</h2>
                    <form method="get" action="registerBack.jsp" target="stuff">
                        jobid: <input type="text" name="jobid"/><br>
                        stamp: <input type="text" name="stamp"/><br>
                        unit_type: <input type="text" name="unit_type"/><br>
                        unit_id: <input type="text" name="unit_id"/><br>
                        job: <input type="text" name="job"/><br>
                        version: <input type="text" name="version"/><br>
                        operator: <input type="text" name="operator"/><br>
                        <input type="submit" value="do it"/>
                    </form>
                </td>
                <td>
                    <h2>Update</h2>
                    <form method="get" action="updateBack.jsp" target="stuff">
                        jobid: <input type="text" name="jobid"/><br>
                        stamp: <input type="text" name="stamp"/><br>
                        step: <input type="text" name="step"/><br>
                        status: <input type="text" name="status"/><br>
                        <input type="submit" value="do it"/>
                    </form>
                </td>
            </tr></table>
        <iframe width="600" height="400" name="stuff"/>
    </body>
</html>
