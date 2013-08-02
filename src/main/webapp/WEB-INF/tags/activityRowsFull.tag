<%-- 
    Document   : activityRowsFull
    Created on : Apr 15, 2013, 10:39:01 AM
    Author     : focke
--%>

<%@tag description="Fills in child activities for activityTable" pageEncoding="US-ASCII"%>
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
    
<sql:query var="childrenQ" dataSource="jdbc/rd-lsst-cam">
    select
    Ap.hardwareId, Ap.inNCR,
    P.id as processId, P.name, P.hardwareRelationshipTypeId,
    PE.id as processEdgeId, PE.step,
    Ac.id as activityId, Ac.begin, Ac.end
    from
    Activity Ap
    inner join ProcessEdge PE on PE.parent=Ap.processId
    inner join Process P on P.id=PE.child
    left join Activity Ac on Ac.parentActivityId=Ap.id and Ac.processEdgeId=PE.id
    where
    Ap.id=?<sql:param value="${activityId}"/>
    order by abs(PE.step);
</sql:query>
    
<c:set var="noneStartedAndUnFinished" value="true"/>
<c:set var="firstUnStarted" value="true"/>
<c:forEach var="childRow" items="${childrenQ.rows}">
    <c:set var="hierStep" value="${prefixDot}${childRow.step}"/>

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
                        <c:when test="${empty childRow.begin}">
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
                            ${childRow.end}
                        </c:when>
                        <c:when test="${! empty childRow.begin}">
                            <c:set var="noneStartedAndUnFinished" value="false"/>
                            <c:set var="currentStepLink" value="${contentLink}" scope="request"/>
<%--                            <traveler:closeoutButton activityId="${childRow.activityId}"/>--%>
                            Needs Work
                        </c:when>
                    </c:choose>
                </td>
            </tr>
            <c:choose>
                <c:when test="${empty childRow.begin}">
                    <traveler:processRows parentId="${childRow.processId}" prefix="${hierStep}" processPath="${myProcessPath}" emptyFields="true"/>                    
                </c:when>
                <c:otherwise>
                    <traveler:activityRowsFull activityId="${childRow.activityId}" prefix="${hierStep}"/>
                </c:otherwise>
            </c:choose>
        </c:when>
                
        <c:otherwise>   
            <c:set var="myProcessPath" value="${processPath}.${childRow.processId}"/>
            <c:url value="displayProcess.jsp" var="childLink">
                <c:param name="processPath" value="${myProcessPath}"/>
            </c:url>
            <c:url var="contentLink" value="processPane.jsp">
                <c:param name="processId" value="${childRow.processId}"/>
                <c:param name="topActivityId" value="${param.activityId}"/>
                <c:if test="${firstUnStarted && noneStartedAndUnFinished}">
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
                    <c:if test="${firstUnStarted && noneStartedAndUnFinished}">
                        <c:set var="firstUnStarted" value="false"/>
                        <c:set var="currentStepLink" value="${contentLink}" scope="request"/>
                        <%--
                        <c:if test="${! empty childRow.hardwareRelationshipTypeId}">
                            <sql:query var="potentialComponentsQ" dataSource="jdbc/rd-lsst-cam">
                                select H.id, H.lsstId, HT.name 
                                from Hardware H, HardwareType HT, HardwareRelationshipType HRT
                                where 
                                HRT.id=?<sql:param value="${childRow.hardwareRelationshipTypeId}"/>
                                and
                                HT.id=HRT.componentTypeId
                                and
                                H.hardwareTypeId=HRT.componentTypeId
                                and 
                                H.hardwareStatusId=(select id from HardwareStatus where name='READY');
                            </sql:query>
                        </c:if>            
                        <c:choose>
                            <c:when test="${(! empty childRow.hardwareRelationshipTypeId) && (empty potentialComponentsQ.rows)}">
                                We're out.
                            </c:when>
                            <c:otherwise>
                                <form METHOD=GET ACTION="createChildActivity.jsp">
                                    <input type="hidden" name="hardwareId" value="${childRow.hardwareId}">       
                                    <input type="hidden" name="inNCR" value="${childRow.inNCR}">
                                    <input type="hidden" name="processId" value="${childRow.processId}">       
                                    <input type="hidden" name="processEdgeId" value="${childRow.processEdgeid}">
                                    <input type="hidden" name="parentActivityId" value="${activityId}">

                                    <c:if test="${! empty childRow.hardwareRelationshipTypeId}">
                                        <select name="componentId">
                                            <c:forEach var="hRow" items="${potentialComponentsQ.rows}" varStatus="status">
                                                <option value="${hRow.id}">${hRow.lsstId}</option>
                                            </c:forEach>
                                        </select>
                                    </c:if>            

                                    <INPUT TYPE=SUBMIT value="Initiate">
                                </form>    
                            </c:otherwise>
                        </c:choose>
                        --%>
                        Needs Prep
                    </c:if>
                </td> 
                <td></td>
            </tr>
            <traveler:processRows parentId="${childRow.processId}" prefix="${hierStep}" processPath="${myProcessPath}" emptyFields="true"/>
        </c:otherwise>
            
    </c:choose>
</c:forEach>
