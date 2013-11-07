<%-- 
    Document   : prereqWidget
    Created on : Jul 15, 2013, 2:32:28 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>

<sql:query var="activityQ" dataSource="jdbc/rd-lsst-cam">
    select A.*, P.hardwareRelationShipTypeId
    from Activity A
    inner join Process P on P.id=A.processId
    where A.id=?<sql:param value="${activityId}"/>
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<traveler:prereqProcesses activityId="${activityId}"/>

<sql:query var="componentQ" dataSource="jdbc/rd-lsst-cam">
    select PP.*, HT.name as hardwareTypeName, H.id as componentId, H.lsstId, PI.creationTS as satisfaction
    from PrerequisitePattern PP
    inner join HardwareType HT on HT.id=PP.hardwareTypeId
            inner join Activity A on A.processId=PP.processId
            left join (Prerequisite PI 
                        inner join Hardware H on H.id=PI.hardwareId)
                on PI.activityId=A.id and PI.prerequisitePatternId=PP.id
            where A.id=?<sql:param value="${activityId}"/>
    and PP.prerequisiteTypeId=(select id from PrerequisiteType where name='COMPONENT')
</sql:query>
<c:if test="${! empty componentQ.rows}">
    <h2>Components</h2>
    <display:table name="${componentQ.rows}" id="row" class="datatable">
        <display:column property="name"/>
        <display:column property="description"/>
        <display:column property="hardwareTypeName"/>
        <display:column title="componentId">
            <c:choose>
                <c:when test="${(! empty row.componentId) and (! empty row.satisfaction)}">
                    <c:url value="displayHardware.jsp" var="hwLink">
                        <c:param name="hardwareId" value="${row.componentId}"/>
                    </c:url>
                    <a href="${hwLink}" target="_top"><c:out value="${row.lsstId}"/></a>
                </c:when>
                <c:when test="${(empty row.componentId) and (empty row.satisfaction)}">
                    <form method="get" action="satisfyPrereq.jsp">
                        <input type="hidden" name="prerequisitePatternId" value="${row.id}">
                        <input type="hidden" name="activityId" value="${activityId}">
                        <input type="hidden" name="hardwareId" value="${activity.hardwareId}">
                        <input type="hidden" name="hardwareRelationshipTypeId" value="${activity.hardwareRelationshipTypeId}">
                        <traveler:componentSelector activityId="${activityId}"/>
                </c:when>
                <c:otherwise>
                    Error <%-- This really shouldn't happen --%>
                </c:otherwise>
            </c:choose>
        </display:column>
        <display:column title="satisfaction">
            <c:choose>
                <c:when test="${(! empty row.componentId) and (! empty row.satisfaction)}">
                    <c:out value="${row.satisfaction}"/>
                </c:when>
                <c:when test="${(empty row.componentId) and (empty row.satisfaction)}">
                    <c:if test="${gotSomeComponents}">
                        <input type="submit" value="Got it">
                    </c:if>
                    </form>
                </c:when>
                <c:otherwise>
                    Error <%-- This really shouldn't happen --%>
                </c:otherwise>
            </c:choose>            
        </display:column>
    </display:table>
</c:if>
    
<traveler:prereqTable prereqTypeName="TEST_EQUIPMENT" activityId="${activityId}"/>
<traveler:prereqTable prereqTypeName="CONSUMABLE" activityId="${activityId}"/>

<c:if test="${empty activity.begin}">
    <sql:query var="prereqQ" dataSource="jdbc/rd-lsst-cam">
        select count(PP.id)-count(PR.id) as prsRemaining from
        PrerequisitePattern PP
        inner join Activity A on A.processId=PP.processId
        left join Prerequisite PR on PR.activityId=A.id and PR.prerequisitePatternId=PP.id
        where A.id=?<sql:param value="${activityId}"/>
    </sql:query>
    <c:if test="${prereqQ.rows[0]['prsRemaining']==0}">
        <form method="get" action="startActivity.jsp" target="_top">
            <input type="hidden" name="activityId" value="${activityId}">       
            <input type="hidden" name="topActivityId" value="${param.topActivityId}">       
            <input type="submit" value="Start Work">
        </form>
    </c:if>
</c:if>
    