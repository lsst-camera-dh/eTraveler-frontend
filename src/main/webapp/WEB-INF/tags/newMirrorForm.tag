<%-- 
    Document   : newMirrorForm
    Created on : Feb 7, 2017, 12:59:33 PM
    Author     : focke
--%>

<%@tag description="A form to add a new mirroring task" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<traveler:fullRequestString var="thisPage"/>
<traveler:checkPerm var="mayAdmin" groups="EtravelerAllAdmin"/>

<form method="get" action="admin/addMirror.jsp">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
    <input type="hidden" name="referringPage" value="${thisPage}">
    <input type="submit" value="Add Mirror Task"
           <c:if test="${! mayAdmin}">disabled</c:if>>
    Name: <input type="text" name="name" required="true">
    Source Directory: <input type="text" name="sourceDirectory" required="true">
    Data Catalog Site: <input type="text" name="dcSite" required="true">
</form>
