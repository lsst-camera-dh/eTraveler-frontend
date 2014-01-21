<%-- 
    Document   : selectionRows
    Created on : Jan 14, 2014, 12:47:35 PM
    Author     : focke
--%>

<%@tag description="Fills in children of selection activities for activityTable" pageEncoding="UTF-8"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>
<%@attribute name="prefix"%>

<traveler:setPaths activityId="${activityId}"/>

<c:if test="${! empty prefix}">
    <c:set var="prefixDot" value="${prefix}."/>
</c:if>

<sql:query var="childrenQ" >
    select
    Ap.hardwareId, Ap.inNCR,
    P.id as processId, P.name, P.hardwareRelationshipTypeId, P.substeps,
    P.travelerActionMask&(select maskBit from InternalAction where name='harnessedJob') as isHarnessed,
    PE.id as processEdgeId, PE.step,
    Ac.id as activityId, Ac.begin, Ac.end,
    AFS.name as statusName
    from
    Activity Ap
    inner join ProcessEdge PE on PE.parent=Ap.processId
    inner join Process P on P.id=PE.child
    inner join Activity Ac on Ac.parentActivityId=Ap.id and Ac.processEdgeId=PE.id
    left join ActivityFinalStatus AFS on AFS.id=Ac.activityFinalStatusId
    where
    Ap.id=?<sql:param value="${activityId}"/>
    order by abs(PE.step);
</sql:query>
    
<c:if test="${empty childrenQ.rows}">
    <%-- Handle like process-only children --%>
    <sql:query var="pidQ">
        select processId from Activity where id=?<sql:param value="${activityId}"/>
    </sql:query>
    <traveler:processRows parentId="${pidQ.rows[0].processId}" prefix="${prefix}" processPath="${processPath}" emptyFields="true"/>                    
</c:if>
    
<c:set var="noneStartedAndUnFinished" value="true"/>
<c:set var="firstUnStarted" value="true"/>
<c:forEach var="childRow" items="${childrenQ.rows}"> <%-- Really should only be zero or one --%>
    <%-- This is copied from activityRowsFull, that's ugly --%>
    <c:set var="hierStep" value="${prefixDot}${childRow.step}"/>

    <c:choose>
        <c:when test="${! empty childRow.activityId}"> <%-- should always be true --%>
            <c:url value="displayActivity.jsp" var="childLink">
                <c:param name="activityId" value="${childRow.activityId}"/>
            </c:url>
            <c:url var="contentLink" value="activityPane.jsp">
                <c:param name="activityId" value="${childRow.activityId}"/>
                <c:param name="topActivityId" value="${param.activityId}"/>
            </c:url>
            <tr>
                <td><a href="${childLink}">${hierStep}</a></td>
                <td><a href="${contentLink}" target="content">${childRow.name}</a></td> 
                <td>
                    <c:choose>
                        <c:when test="${(empty childRow.begin) && (not travelerFailed)}">
                            <c:set var="noneStartedAndUnFinished" value="false"/>
                            <c:set var="currentStepLink" value="${contentLink}" scope="request"/>
                            In Prep
                        </c:when>
                        <c:otherwise>
                            ${childRow.begin}
                        </c:otherwise>
                    </c:choose>
                </td> 
                <td>
                    <c:choose>
                        <c:when test="${! empty childRow.end}">
                            ${childRow.statusName} ${childRow.end}
                        </c:when>
                        <c:when test="${! empty childRow.begin}">
                            <c:choose>
                                <c:when test="${(childRow.isHarnessed==0) && (not travelerFailed)}">
                                    <c:set var="noneStartedAndUnFinished" value="false"/>
                                    <c:set var="currentStepLink" value="${contentLink}" scope="request"/>
                                    Needs Work
                                </c:when>
                                <c:otherwise>
                                    JH In Progress
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                    </c:choose>
                </td>
            </tr>
            <c:choose>
                <c:when test="${empty childRow.begin && childRow.substeps != 'NONE'}">
                    <traveler:processRows parentId="${childRow.processId}" prefix="${hierStep}" processPath="${myProcessPath}" emptyFields="true"/>                    
                </c:when>
                <c:when test="${childRow.substeps == 'SEQUENCE'}">
                    <traveler:activityRowsFull activityId="${childRow.activityId}" prefix="${hierStep}"/>
                </c:when>
                <c:when test="${childRow.substeps == 'SELECTION'}">
                    <traveler:selectionRows activityId="${childRow.activityId}" prefix="${hierStep}"/>
                </c:when>
            </c:choose>
        </c:when>
    </c:choose>
</c:forEach>