<%-- 
    Document   : processInputWidget
    Created on : Dec 12, 2013, 10:53:20 AM
    Author     : focke
--%>

<%@tag description="Display InputPatterns for a Process" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="processId" required="true"%>

<sql:query var="inputQ" >
    select count(*) as count
    from InputPattern IP
    inner join InputSemantics ISm on ISm.id=IP.inputSemanticsId
    where IP.processId=?<sql:param value="${processId}"/>
    and ISm.name!='signature'
    order by IP.id;
</sql:query>

<c:if test="${inputQ.rows[0].count != 0}">
    <h2>Instructions and Results</h2>
    <traveler:processInputTable processId="${processId}" optional="0"/>
    <traveler:processInputTable processId="${processId}" optional="1"/>
</c:if>