<%-- 
    Document   : basicDecorator
    Created on : Jun 4, 2015, 11:36:59 AM
    Author     : focke
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Strict//EN">
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@taglib prefix="dec" tagdir="/WEB-INF/tags/decorators"%>
<%@taglib prefix="srs_utils" uri="http://srs.slac.stanford.edu/utils"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
    <head>
        <title>
            ${appVariables.experiment} ${initParam.applicationTitle} - <decorator:title default="Welcome!" />
        </title>
            <dec:style/>
            <style type="text/css">
table.datatable th, table.datatable td {
	text-align: left;
}
            </style>
    <decorator:head />
    </head>

    <body >
        <table width="100%" border="0" >
            <tr>
                <td id="headerElement">
                    <dec:headerDecorator/>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="pageBody">
                        <decorator:body />
                    </div>
                </td>
            </tr>
            <tr>
                <td id="footerElement" >
                    <dec:footerDecorator />
                </td>
            </tr>
        </table>
        <c:if test="${empty freshnessGenerator}">
            <c:set var="freshnessGenerator" value="<%= new java.util.Random() %>" scope="session"/>
            <c:set var="freshnessToken" value="${freshnessGenerator.nextLong()}" scope="session"/>
        </c:if>
    </body>
</html>

