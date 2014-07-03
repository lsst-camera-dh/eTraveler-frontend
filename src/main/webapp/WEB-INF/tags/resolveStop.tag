<%-- 
    Document   : resolveStop
    Created on : Jun 18, 2014, 2:53:53 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>
<%@attribute name="travelerId" required="true"%>

<%-- any content can be specified here e.g.: --%>
<table>
    <tr>
        <td>
            <form method="get" action="fh/restartTraveler.jsp" target="_top">
                <input type="hidden" name="activityId" value="${travelerId}">
                <input type="submit" value="Restart"
                       <%--<c:if test="${! restartable}">disabled</c:if>--%>>
            </form>
        </td>
        <td>
            <form METHOD=GET ACTION="fh/retryActivity.jsp" target="_top">
                <input type="hidden" name="activityId" value="${activityId}">       
                <input type="hidden" name="topActivityId" value="${travelerId}">       
                <INPUT TYPE=SUBMIT value="Try Again"
                       <%--<c:if test="${! retryable}">disabled</c:if>--%>>
            </form>
        </td>
        <td>
            <%--
            <form method="get" action="doNCR.jsp" target="_top">
                <input type="hidden" name="activityId" value="${activityId}">       
                <input type="hidden" name="topActivityId" value="${travelerId}">       
                <INPUT TYPE=SUBMIT value="NCR"
            </form>
            --%>
            <traveler:selectNCR activityId="${activityId}"/>
        </td>
        <td>
            <form METHOD=GET ACTION="fh/failActivity.jsp" target="_top">
                <input type="hidden" name="activityId" value="${activityId}">       
                <input type="hidden" name="topActivityId" value="${travelerId}">
                <input type="hidden" name="status" value="failure">
                <INPUT TYPE=SUBMIT value="Fail"
                       <%--<c:if test="${! failable}">disabled</c:if>--%>>
            </form>
        </td>
    </tr>
</table>