<%-- 
    Document   : prereqWidget
    Created on : Jul 15, 2013, 2:32:28 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>
<%--
<sql:query var="prereqQ" dataSource="jdbc/rd-lsst-cam">
    select PP.*, PT.name as type, PI.*
    from PrerequisitePattern PP
    inner join PrerequisiteType PT on PT.id=PP.prerequisiteTypeId
    inner join Activity A on PP.processId=A.processId
    left join Process P on PP.prereqProcessId=P.id
    left join HardwareType HT on PP.hardwareTypeId=HT.id
    left join Prerequisite PI on PI.activityId=A.id
    where A.id=?<sql:param value="${activityId}"/>
</sql:query>

<c:if test="${! empty prereqQ.rows}">
    <h2>Prerequisites</h2>

    <display:table name="${prereqQ.rows}" class="datatable">
        <display:column property="name"/>
        <display:column property="description"/>
        <display:column property="type"/>
        <display:column property="quantity"/>
    </display:table>
</c:if>
--%>

<sql:query var="componentQ" dataSource="jdbc/rd-lsst-cam">
    select PP.*, HT.name as hardwareTypeName
    from PrerequisitePattern PP
    inner join HardwareType HT on HT.id=PP.hardwareTypeId
    where PP.prerequisiteTypeId=(select id from PrerequisiteType where name='COMPONENT')
    and PP.processId=?<sql:param value="${processId}"/>
</sql:query>
<c:if test="${! empty componentQ.rows}">
    <h2>Components</h2>
    <display:table name="${componentQ.rows}" class="datatable">
        <display:column property="name"/>
        <display:column property="description"/>
        <display:column property="hardwareTypeName"/>
    </display:table>
</c:if>
    
<sql:query var="testEqQ" dataSource="jdbc/rd-lsst-cam">
    select PP.*, PI.creationTS as satisfaction
    from PrerequisitePattern PP
    inner join Activity A on A.processId=PP.processId
    left join Prerequisite PI on PI.activityId=A.id and PI.prerequisitePatternId=PP.id
    where A.id=?<sql:param value="${activityId}"/>
    and PP.prerequisiteTypeId=(select id from PrerequisiteType where name='TEST_EQUIPMENT')
</sql:query>
<c:if test="${! empty testEqQ.rows}">
    <h2>Test Equipment</h2>
    <display:table name="${testEqQ.rows}" id="row" class="datatable">
        <display:column property="name"/>
        <display:column property="description"/>
        <display:column property="quantity"/>        
        <display:column title="satisfaction">
            <c:choose>
                <c:when test="${! empty row.satisfaction}">
                    <c:out value="${row.satisfaction}"/>
                </c:when>
                <c:otherwise>
                    <form method="get" action="satisfyPrereq.jsp">
                        <input type="hidden" name="prerequisitePatternId" value="${row.id}">
                        <input type="hidden" name="activityId" value="${activityId}">
                        <input type="submit" value="Got it">
                    </form>
                </c:otherwise>
            </c:choose>
        </display:column>
    </display:table>
</c:if>
    
<sql:query var="consumablesQ" dataSource="jdbc/rd-lsst-cam">
    select PP.*, PI.creationTS as satisfaction
    from PrerequisitePattern PP
    inner join Activity A on A.processId=PP.processId
    left join Prerequisite PI on PI.activityId=A.id and PI.prerequisitePatternId=PP.id
    where A.id=?<sql:param value="${activityId}"/>
    and PP.prerequisiteTypeId=(select id from PrerequisiteType where name='CONSUMABLE')
</sql:query>
<c:if test="${! empty consumablesQ.rows}">
    <h2>Consumables</h2>
    <display:table name="${consumablesQ.rows}" id="row" class="datatable">
        <display:column property="name"/>
        <display:column property="description"/>
        <display:column property="quantity"/>
        <display:column title="satisfaction">
            <c:choose>
                <c:when test="${! empty row.satisfaction}">
                    <c:out value="${row.satisfaction}"/>
                </c:when>
                <c:otherwise>
                    <form method="get" action="satisfyPrereq.jsp">
                        <input type="hidden" name="prerequisitePatternId" value="${row.id}">
                        <input type="hidden" name="activityId" value="${activityId}">
                        <input type="submit" value="Got it">
                    </form>
                </c:otherwise>
            </c:choose>
        </display:column>
    </display:table>
</c:if>

<sql:query var="activityQ" dataSource="jdbc/rd-lsst-cam">
    select * from Activity where id=?<sql:param value="${activityId}"/>
</sql:query>
<c:if test="${empty activityQ.rows[0].begin}"> 
    <form method="get" action="startActivity.jsp" target="_top">
        <input type="hidden" name="activityId" value="${activityId}">       
        <input type="hidden" name="topActivityId" value="${param.topActivityId}">       
        <input type="submit" value="Start Work">
    </form>
</c:if>
    