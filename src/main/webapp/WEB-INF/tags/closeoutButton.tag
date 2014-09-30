<%-- 
    Document   : closeoutButton
    Created on : Apr 11, 2013, 12:06:18 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>

<sql:query var="activityQ" >
    select A.*, P.substeps, P.maxIteration,
    P.travelerActionMask&(select maskBit from InternalAction where name='harnessedJob') as isHarnessed,
    P.travelerActionMask&(select maskBit from InternalAction where name='async') as isAsync 
    from Activity A
    inner join Process P on P.id=A.processId
    where A.id=?<sql:param value="${activityId}"/>;
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<c:set var="message" value="bug 696274"/>
<c:set var="readyToClose" value="false"/>
<c:set var="closed" value="false"/>
<c:choose>
    <c:when test="${empty activity.begin}">
        <c:set var="message" value="Not started"/>
    </c:when>
    <c:when test="${empty activity.end}">
        <c:set var="message" value="Needs work"/>
        <c:choose>
            <c:when test="${activity.isAsync != 0}">
                <c:set var="message" value="Async job in progress"/>
            </c:when>
            <c:when test="${activity.isHarnessed != 0}">
                <c:set var="message" value="Harnessed job in progress"/>
            </c:when>
            <c:when test="${activity.substeps == 'SEQUENCE'}">
                <sql:query var="stepsRemainingQ" >
                    select Ac.id
                    from Activity Ap
                    inner join ProcessEdge PE on PE.parent=Ap.processId
                    left join Activity Ac on Ac.processEdgeId=PE.id and Ac.parentActivityId=Ap.id
                    where Ap.id=?<sql:param value="${activityId}"/>
                    and Ac.end is null    
                </sql:query>
                <c:if test="${empty stepsRemainingQ.rows}">
                    <c:set var="readyToClose" value="true"/>
                </c:if>
            </c:when>
            <c:when test="${activity.substeps == 'SELECTION'}">
                <sql:query var="childQ">
                    select count(*) as completedSteps
                    from Activity A where
                    A.parentActivityId=?<sql:param value="${activityId}"/>
                    and A.end is not null
                </sql:query>
                <c:if test="${childQ.rows[0].completedSteps != 0}">
                    <c:set var="readyToClose" value="true"/>
                </c:if>
            </c:when>
            <c:when test="${activity.substeps == 'NONE'}">
                <c:set var="readyToClose" value="true"/>                
            </c:when>
        </c:choose>
    </c:when>
    <c:otherwise>
<%--        Closed out at ${activity.rows[0]['end']} by <c:out value="${activity.rows[0]['closedBy']}"/>--%>
        <c:set var="message" value="${activity.end}"/>
        <c:set var="closed" value="true"/>
    </c:otherwise>
</c:choose>

<traveler:isStopped var="isStopped" activityId="${activityId}"/>
<c:if test="${isStopped}">
    <%-- This seems an ugly hack. --%>
    <c:set var="readyToClose" value="false"/>
</c:if>

<c:set var="retryable" value="${activity.iteration < activity.maxIteration && readyToClose}"/>
<c:if test="${readyToClose}">
    <c:set var="message" value="Ready to close"/>
</c:if>
<c:set var="failable" value="${! closed && ! travelerFailed}"/> <%-- Argh. travelerFailed is not set in ActivityPane --%>

<c:out value="${message}"/><br>
<table>
    <tr>
        <td>
            <form METHOD=GET ACTION="fh/closeoutActivity.jsp" target="_top">
                <input type="hidden" name="activityId" value="${activityId}">       
                <input type="hidden" name="topActivityId" value="${param.topActivityId}">       
                <INPUT TYPE=SUBMIT value="Closeout Success"
                       <c:if test="${! readyToClose}">disabled</c:if>>
            </form>      
        </td>
        <td>
            <form METHOD=GET ACTION="fh/retryActivity.jsp" target="_top">
                <input type="hidden" name="activityId" value="${activityId}">       
                <input type="hidden" name="topActivityId" value="${param.topActivityId}">       
                <INPUT TYPE=SUBMIT value="Retry Step"
                       <c:if test="${! retryable}">disabled</c:if>>
            </form>
        </td>
        <td>
            <form METHOD=GET ACTION="stopWork.jsp" target="_top">
                <input type="hidden" name="activityId" value="${activityId}">       
                <input type="hidden" name="topActivityId" value="${param.topActivityId}">       
                <%--<input type="hidden" name="status" value="stopped">--%>
                <INPUT TYPE=SUBMIT value="Stop Work"
                       <c:if test="${(! failable) || isStopped}">disabled</c:if>>
            </form>                  
        </td>
        <%--
        <td>
            <form METHOD=GET ACTION="fh/failActivity.jsp" target="_top">
                <input type="hidden" name="activityId" value="${activityId}">       
                <input type="hidden" name="topActivityId" value="${param.topActivityId}">
                <input type="hidden" name="status" value="failure">
                <INPUT TYPE=SUBMIT value="Fail"
                       <c:if test="${! failable}">disabled</c:if>>
            </form>                  
        </td>
        --%>
        <td>
            <form METHOD=GET ACTION="resolveStop.jsp" target="_top">
                <input type="hidden" name="activityId" value="${activityId}">       
                <INPUT TYPE=SUBMIT value="Resolve Stop Work"
                       <c:if test="${! isStopped}">disabled</c:if>>
            </form>                              
        </td>
    </tr>
</table>
