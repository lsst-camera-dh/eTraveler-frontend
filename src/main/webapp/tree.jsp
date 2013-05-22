<%-- 
    Document   : tree
    Created on : May 14, 2013, 2:34:51 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="US-ASCII"%>
<%@taglib prefix="tree" uri="http://java.freehep.org/tree-taglib" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            org.freehep.webutil.tree.DefaultTreeNode root = new org.freehep.webutil.tree.DefaultTreeNode("root");
            root.setHref("listHardwareTypes.jsp");
            root.setTarget("content");
            root.createNodeAtPath("A");
            org.freehep.webutil.tree.DefaultTreeNode nodeAa = new org.freehep.webutil.tree.DefaultTreeNode("a");
            nodeAa.setHref("listTravelerTypes.jsp");
            nodeAa.setTarget("content");
            root.addNodeAtPath(nodeAa, "A");
            root.createNodeAtPath("/A/B");
            root.createNodeAtPath("/A/B/b/");
            root.createNodeAtPath("/A/B/c");
            session.setAttribute("root", root);
        %>
        <table>
            <tr>
                <td>
                    <tree:tree model="${root}"/>
                </td>
                <td>
                    <iframe name="content"></iframe>
                </td>
            </tr>
        </table>
    </body>
</html>
