<%-- 
    Document   : travelerTypeStatusForm
    Created on : Apr 6, 2015, 11:10:09 AM
    Author     : focke
--%>

<%@tag description="A form to change the status of a TravelerType" pageEncoding="UTF-8"%>

<%@attribute name="travelerTypeId"%>

<form action="fh/updateTravelerType.jsp" method="get">
    <input type="submit" value="Update Traveler Type Status">
    <input type="hidden" name="travelerTypeId" value="${travelerTypeId}">
    <select name="status">
        <option value="ACTIVE">ACTIVE</option>
        <option value="DEACTIVATED">DEACTIVATED</option>
        <option value="SUPERSEDED">SUPERSEDED</option>
    </select>            
</form>