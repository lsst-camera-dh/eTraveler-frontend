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
<%@attribute name="processId" required="true"%>
    
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
    
<traveler:prereqTable prereqTypeName="TEST_EQUIPMENT" processId="${processId}"/>
<traveler:prereqTable prereqTypeName="CONSUMABLE" processId="${processId}"/>