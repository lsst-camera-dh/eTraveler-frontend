<%-- 
    Document   : closeoutButton
    Created on : Apr 11, 2013, 12:06:18 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>

<sql:query var="activityQ" >
    select A.*, P.substeps,
    P.travelerActionMask&(select maskBit from InternalAction where name='harnessedJob') as isHarnessed 
    from Activity A
    inner join Process P on P.id=A.processId
    where A.id=?<sql:param value="${activityId}"/>;
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<c:set var="readyToClose" value="false"/>
<c:choose>
    <c:when test="${empty activity.begin}">
        <c:set var="message" value="Not started"/>
    </c:when>
    <c:when test="${empty activity.end}">
        <c:set var="message" value="Needs work"/>
        <c:choose>
            <c:when test="${activity.isHarnessed!=0}">
                <c:set var="message" value="JH in progress"/>
            </c:when>
            <c:when test="${activity.substeps == 'SEQUENCE'}">
                <sql:query var="stepsRemainingQ" >
                    select (
                        (select count(*) from ProcessEdge where parent=?<sql:param value="${activity.processId}"/>) 
                        -
                        (select count(*) from Activity A 
                     <%--    inner join Process P on P.id=A.processId --%>
                        where 
                        A.parentActivityId=?<sql:param value="${activityId}"/>
                        and (
                                A.end is not null
                           <%--     or (A.begin is not null and P.travelerActionMask&(select maskBit from InternalAction where name='harnessedJob')!=0) --%>
                            )
                        ) 
                    ) stepsRemaining from dual;
                </sql:query>
                <c:if test="${stepsRemainingQ.rows[0]['stepsRemaining']==0}">
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
    </c:otherwise>
</c:choose>
<c:choose>
    <c:when test="${readyToClose == 'true'}">
        <form METHOD=GET ACTION="closeoutActivity.jsp" target="_top">
            <input type="hidden" name="activityId" value="${activityId}">       
            <input type="hidden" name="topActivityId" value="${param.topActivityId}">       
            <INPUT TYPE=SUBMIT value="Closeout">
        </form>        
    </c:when>
    <c:otherwise>
        <c:out value="${message}"/>
    </c:otherwise>
</c:choose>