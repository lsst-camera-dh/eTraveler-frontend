<%-- 
    Document   : activityRowsFull
    Created on : Apr 15, 2013, 10:39:01 AM
    Author     : focke
--%>

<%@tag description="Fills in children of activities for activityTable" pageEncoding="US-ASCII"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>
<%@attribute name="prefix"%>

<c:set var="autoStart" value="true"/>

<traveler:setPaths activityId="${activityId}"/>
<c:set var="thisProcessPath" value="${processPath}"/>

<c:if test="${! empty prefix}">
    <c:set var="prefixDot" value="${prefix}."/>
</c:if>
    
<sql:query var="childrenQ" >
    select
    Ap.hardwareId, Ap.inNCR,
    P.id as processId, P.name, P.hardwareRelationshipTypeId, P.substeps,
    P.travelerActionMask&(select maskBit from InternalAction where name='async') as isAsync,
    PE.id as processEdgeId, PE.step,
    Ac.id as activityId, Ac.begin, Ac.end,
    AFS.name as statusName,
    JSH.id as jobStepId
    from
    Activity Ap
    inner join ProcessEdge PE on PE.parent=Ap.processId
    inner join Process P on P.id=PE.child
    left join Activity Ac on Ac.parentActivityId=Ap.id and Ac.processEdgeId=PE.id
    left join ActivityFinalStatus AFS on AFS.id=Ac.activityFinalStatusId
    left join JobStepHistory JSH on JSH.activityId=Ac.id
    where
    Ap.id=?<sql:param value="${activityId}"/>
    group by PE.id, Ac.id
    order by abs(PE.step), Ac.iteration;
</sql:query>
    
<c:set var="noneStartedAndUnFinished" value="true"/>
<c:set var="firstUnStarted" value="true"/>
<c:forEach var="childRow" items="${childrenQ.rows}">
    <c:set var="hierStep" value="${prefixDot}${childRow.step}"/>
    <c:set var="myProcessPath" value="${thisProcessPath}.${childRow.processId}"/>

    <c:choose>
        <c:when test="${! empty childRow.activityId}">
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
                                <c:when test="${childRow.isAsync!=0 && ! empty childRow.jobStepId}">
                                    Async Job In Progress
                                </c:when>
                                <c:when test="${not travelerFailed}">
                                    <c:set var="noneStartedAndUnFinished" value="false"/>
                                    <c:set var="currentStepLink" value="${contentLink}" scope="request"/>
                                    Needs Work
                                </c:when>
<%--                                <c:otherwise>
                                    JH In Progress
                                </c:otherwise>--%>
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
                
        <c:otherwise> 
            <c:url value="displayProcess.jsp" var="childLink">
                <c:param name="processPath" value="${myProcessPath}"/>
            </c:url>
            <c:choose>
                <c:when test="${autoStart && firstUnStarted && noneStartedAndUnFinished && ! travelerFailed}">
                    <c:set var="contentUrl" value="fh/createActivity.jsp"/>
                </c:when>
                <c:otherwise>
                    <c:set var="contentUrl" value="processPane.jsp"/>
                </c:otherwise>
            </c:choose>
            <c:url var="contentLink" value="${contentUrl}">
                <c:param name="processId" value="${childRow.processId}"/>
                <c:param name="topActivityId" value="${param.activityId}"/>
                <c:if test="${firstUnStarted && noneStartedAndUnFinished && ! travelerFailed}"> <%-- Supply extra args to create an Activity for the Process --%>
                    <c:param name="parentActivityId" value="${activityId}"/>
                    <c:param name="processEdgeId" value="${childRow.processEdgeId}"/>
                    <c:param name="hardwareId" value="${childRow.hardwareId}"/>       
                    <c:param name="inNCR" value="${childRow.inNCR}"/>
                 </c:if>
            </c:url>
            <tr>
                <td><a href="${childLink}">${hierStep}</a></td>
                <td><a href="${contentLink}" target="content">${childRow.name}</a></td> 
                <td>
                    <c:if test="${(firstUnStarted && noneStartedAndUnFinished) && (not travelerFailed)}">
                        <c:set var="firstUnStarted" value="false"/>
                        <c:set var="currentStepLink" value="${contentLink}" scope="request"/>
                        <c:choose>
                            <c:when test="${autoStart}">
                                <c:set var="startNextStep" value="true" scope="request"/>
                            </c:when>
                            <c:otherwise>
                                Needs Prep
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                </td> 
                <td></td>
            </tr>
            <c:if test="${childRow.substeps != 'NONE'}">
                <traveler:processRows parentId="${childRow.processId}" prefix="${hierStep}" processPath="${myProcessPath}" emptyFields="true"/>
            </c:if>
        </c:otherwise>
            
    </c:choose>
</c:forEach>
