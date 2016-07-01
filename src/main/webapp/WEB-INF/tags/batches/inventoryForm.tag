<%-- 
    Document   : inventoryForm
    Created on : Jun 17, 2016, 4:15:35 PM
    Author     : focke
--%>

<%@tag description="show forms to add or remove items from a batch" pageEncoding="UTF-8"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="hardwareId" required="true"%>
<%@attribute name="quantity" required="true"%>

<traveler:fullRequestString var="thisPage"/>

<form action="batches/adjustInventory.jsp">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
    <input type="hidden" name="referringPage" value="${thisPage}">
    <input type="hidden" name="hardwareId" value="${hardwareId}">
    <input type="hidden" name="sign" value="-1">
    <input type="submit" value="Remove Some">
    How many?&nbsp;<input type="number" name="adjustment" min="1" max="${quantity}" required>
    Why?&nbsp;<input type="text" name="reason">
</form>

<form action="batches/adjustInventory.jsp">
    <input type="hidden" name="freshnessToken" value="${freshnessToken}">
    <input type="hidden" name="referringPage" value="${thisPage}">
    <input type="hidden" name="hardwareId" value="${hardwareId}">
    <input type="hidden" name="sign" value="1">
    <input type="submit" value="Add Some">
    How many?&nbsp;<input type="number" name="adjustment" min="1" required>
    Why?&nbsp;<input type="text" name="reason">
</form>
