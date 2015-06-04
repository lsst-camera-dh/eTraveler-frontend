<%-- 
    Document   : resolveStop
    Created on : Jun 18, 2014, 2:53:53 PM
    Author     : focke
--%>

<%@tag description="Provide various ways to resume work on a stopped process traveler" pageEncoding="UTF-8"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="travelerId" required="true"%>

<traveler:checkPerm var="maySupervise" groups="EtravelerSupervisor"/>

<table border="1">
    <tr>
        <td>
            <form method="get" action="supervisor/resumeTraveler.jsp" target="_top">
                <input type="hidden" name="activityId" value="${travelerId}">
                <input type="submit" value="Resume Work"
                    <c:if test="${! maySupervise}">disabled</c:if>>
            </form>
        </td>
        <td>
            <form METHOD=GET ACTION="operator/retryActivity.jsp" target="_top">
                <input type="hidden" name="activityId" value="${activityId}">       
                <input type="hidden" name="topActivityId" value="${travelerId}">       
                <INPUT TYPE=SUBMIT value="Retry Step"
                    <c:if test="${! maySupervise}">disabled</c:if>>
            </form>
        </td>
        <td>
            <form METHOD=GET ACTION="supervisor/skipStep.jsp" target="_top">
                <input type="hidden" name="activityId" value="${activityId}">       
                <input type="hidden" name="topActivityId" value="${travelerId}">       
                <INPUT TYPE=SUBMIT value="Skip Step"
                    <c:if test="${! maySupervise}">disabled</c:if>>
            </form>            
        </td>
        <td>
            <traveler:selectNCR activityId="${activityId}"/>
        </td>
        <td>
            <form METHOD=GET ACTION="supervisor/failActivity.jsp" target="_top">
                <input type="hidden" name="activityId" value="${activityId}">       
                <input type="hidden" name="topActivityId" value="${travelerId}">
                <input type="hidden" name="status" value="failure">
                <INPUT TYPE=SUBMIT value="Fail Traveler"
                    <c:if test="${! maySupervise}">disabled</c:if>>
            </form>
        </td>
    </tr>
</table>