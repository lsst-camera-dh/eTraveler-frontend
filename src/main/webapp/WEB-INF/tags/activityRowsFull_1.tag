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
    
<sql:query var="activityQ" dataSource="jdbc/rd-lsst-cam">
    select * from Activity where id=?<sql:param value="${activityId}"/>;
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<sql:query var="startedChildrenQ" dataSource="jdbc/rd-lsst-cam">
    select A.id, A.begin, A.end, P.name, PE.step
    from Activity A, Process P, ProcessEdge PE
    where A.parentActivityId=?<sql:param value="${activityId}"/>
    and
    P.id=A.processId
    and
    PE.id=A.processEdgeId
    order by step;
</sql:query>

<sql:query var="unStartedChildrenQ" dataSource="jdbc/rd-lsst-cam">
    select P.id, P.name, P.hardwareRelationshipTypeId, PE.id as processEdgeId, PE.step
    from Process P, ProcessEdge PE
    where
    PE.parent=?<sql:param value="${activity.processId}"/>
    and
    P.id=PE.child
    and
    PE.id not in (select processEdgeId from Activity where parentActivityId=?<sql:param value="${activityId}"/>)
    order by step;
</sql:query>    

<c:set var="noneStartedAndUnFinished" value="true"/>
<c:forEach var="aRow" items="${startedChildrenQ.rows}">
    <c:set var="hierStep" value="${prefixDot}${aRow.step}"/>

    <tr>
        <td><a href="displayActivity.jsp?activityId=${aRow.id}">${hierStep}</a></td>
        <td>${aRow.name}</td> <td>${aRow.begin}</td> 
        <td>
            <c:choose>
                <c:when test="${! empty aRow.end}">
                    ${aRow.end}
                </c:when>
                <c:otherwise>
                    <c:set var="noneStartedAndUnFinished" value="false"/>
                    <traveler:closeoutButton activityId="${aRow.id}"/>
                </c:otherwise>
            </c:choose>
        </td>
    </tr>
    <traveler:activityRowsFull activityId="${aRow.id}" prefix="${hierStep}"/>
</c:forEach>
                
<c:forEach var="pRow" items="${unStartedChildrenQ.rows}" varStatus="status">
    <c:set var="hierStep" value="${prefixDot}${pRow.step}"/>
    <c:set var="myProcessPath" value="${processPath}.${pRow.id}"/>
    <c:url value="dumpProcess.jsp" var="childLink">
        <c:param name="processPath" value="${myProcessPath}"/>
    </c:url>
    <tr>
        <td><a href="${childLink}">${hierStep}</a></td>
        <td>${pRow.name}</td> 
        <td>
            <c:if test="${status.first && noneStartedAndUnFinished}">
                <c:if test="${! empty pRow.hardwareRelationshipTypeId}">
                    <sql:query var="potentialComponentsQ" dataSource="jdbc/rd-lsst-cam">
                        select H.id, H.lsstId, HT.name 
                        from Hardware H, HardwareType HT, HardwareRelationshipType HRT, Activity A
                        where 
                        HRT.id=?<sql:param value="${pRow.hardwareRelationshipTypeId}"/>
                        and
                        HT.id=HRT.componentTypeId
                        and
                        H.typeId=HRT.componentTypeId
                        and 
                        H.id=A.hardwareId and A.end is not null and A.parentActivityId is null
                        and
                        H.id not in (select componentId from HardwareRelationship where end is null);
                    </sql:query>
                </c:if>            
                <c:choose>
                    <c:when test="${(! empty pRow.hardwareRelationshipTypeId) && (empty potentialComponentsQ.rows)}">
                        We're out.
                    </c:when>
                    <c:otherwise>
                        <form METHOD=GET ACTION="createChildActivity.jsp">
                            <input type="hidden" name="hardwareId" value="${activity.hardwareId}">       
                            <input type="hidden" name="inNCR" value="${activity.inNCR}">
                            <input type="hidden" name="processId" value="${pRow.id}">       
                            <input type="hidden" name="processEdgeId" value="${pRow.processEdgeid}">
                            <input type="hidden" name="parentActivityId" value="${activityId}">

                            <c:if test="${! empty pRow.hardwareRelationshipTypeId}">
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
            </c:if>
        </td> 
        <td></td>
    </tr>
    <traveler:processRows parentId="${pRow.id}" prefix="${hierStep}" processPath="${myProcessPath}" emptyFields="true"/>
</c:forEach>
