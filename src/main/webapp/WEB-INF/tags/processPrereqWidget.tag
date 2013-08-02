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
<%@attribute name="processId" required="true"%>
<%--
<sql:query var="prereqQ" dataSource="jdbc/rd-lsst-cam">
    select PP.*, PT.name as type
    from PrerequisitePattern PP
    inner join PrerequisiteType PT on PT.id=PP.prerequisiteTypeId
    left join Process P on PP.prereqProcessId=P.id
    left join HardwareType HT on PP.hardwareTypeId=HT.id
    where PP.processId=?<sql:param value="${processId}"/>
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
    select PP.*
    from PrerequisitePattern PP
    where PP.prerequisiteTypeId=(select id from PrerequisiteType where name='TEST_EQUIPMENT')
    and PP.processId=?<sql:param value="${processId}"/>
</sql:query>
<c:if test="${! empty testEqQ.rows}">
    <h2>Test Equipment</h2>
    <display:table name="${testEqQ.rows}" class="datatable">
        <display:column property="name"/>
        <display:column property="description"/>
        <display:column property="quantity"/>        
    </display:table>
</c:if>
    
<sql:query var="consumablesQ" dataSource="jdbc/rd-lsst-cam">
    select PP.*
    from PrerequisitePattern PP
    where PP.prerequisiteTypeId=(select id from PrerequisiteType where name='CONSUMABLE')
    and PP.processId=?<sql:param value="${processId}"/>  
</sql:query>
<c:if test="${! empty consumablesQ.rows}">
    <h2>Consumables</h2>
    <display:table name="${consumablesQ.rows}" class="datatable">
        <display:column property="name"/>
        <display:column property="description"/>
        <display:column property="quantity"/>        
    </display:table>
</c:if>
    