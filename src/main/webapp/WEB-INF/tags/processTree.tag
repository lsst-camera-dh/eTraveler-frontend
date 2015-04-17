<%-- 
    Document   : processTree
    Created on : Mar 27, 2013, 12:28:50 PM
    Author     : focke
--%>

<%@tag description="A tree showing a process and all its children" pageEncoding="US-ASCII"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="tree" uri="http://java.freehep.org/tree-taglib"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="processId" required="true"%>

<sql:query var="meQ" >
    select * from Process where id=?<sql:param value="${processId}"/>;
</sql:query>

<%
    org.freehep.webutil.tree.DefaultTreeNode root = new org.freehep.webutil.tree.DefaultTreeNode("root");
    root.setHref("listHardwareTypes.jsp");
    root.setTarget("content");
    request.setAttribute("root", root);
%>
<tree:tree model="${root}"/>
