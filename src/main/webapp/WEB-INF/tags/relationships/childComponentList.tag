<%-- 
    Document   : childComponentList
    Created on : Apr 9, 2013, 1:55:08 PM
    Author     : focke
--%>

<%@tag description="Make a list representing the tree of child components in an assembly" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="relationships" tagdir="/WEB-INF/tags/relationships"%>

<%@attribute name="hardwareId" required="true"%>
<%@attribute name="noBatched"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="compList" scope="AT_BEGIN"%>
<%@attribute name="mode" required="true"%>

<%
    java.util.List compList = new java.util.LinkedList();
    jspContext.setAttribute("compList", compList);
%>

<relationships:childComponentRows hardwareId="${hardwareId}" 
                             level="0" 
                             noBatched="${noBatched}" 
                             compList="${compList}"
                             mode="${mode}"/>
