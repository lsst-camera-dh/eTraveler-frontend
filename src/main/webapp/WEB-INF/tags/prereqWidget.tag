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
<%@attribute name="parentActivityId"%>
<%@attribute name="processEdgeId"%>

<h2>Prerequisites</h2>

<sql:query var="prereqQ" dataSource="jdbc/rd-lsst-cam">
    select PP.*, PT.name as type
    from PrerequisitePattern PP
    inner join PrerequisiteType PT on PT.id=PP.prerequisiteTypeId
    where PP.processId=?<sql:param value="${processId}"/>
</sql:query>
    
<form target="none.html">
    <display:table name="${prereqQ.rows}" class="datatable">
        <display:column property="name"/>
        <display:column property="description"/>
        <display:column property="type"/>
        <display:column property="quantity"/>
        <display:column title="fred">
            <input type="text"/>
        </display:column>
    </display:table>
    <input type="submit" value="jake" <c:if test="${true}">disabled</c:if>/>
</form>